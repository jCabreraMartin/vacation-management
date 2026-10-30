using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using VacationManagement.Api;

namespace VacationManagement.IntegrationTests;

public sealed class LocalOnlyApiTests : IDisposable
{
    private readonly WebApplicationFactory<Program> _factory = new();

    public void Dispose() => _factory.Dispose();

    [Theory]
    [InlineData("http://0.0.0.0:5080")]
    [InlineData("http://[::]:5080")]
    [InlineData("http://*:5080")]
    [InlineData("http://192.0.2.1:5080")]
    [InlineData("http://localhost:5080;http://0.0.0.0:5090")]
    public void Non_loopback_listeners_are_rejected_before_startup(string urls)
    {
        using var factory = _factory.WithWebHostBuilder(builder => builder.UseSetting("urls", urls));

        var error = Assert.Throws<InvalidOperationException>(() => factory.CreateClient());

        Assert.Contains("loopback", error.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task A_simple_cross_origin_write_is_forbidden_without_changing_the_request()
    {
        using var client = _factory.CreateClient();
        using var message = new HttpRequestMessage(HttpMethod.Post, "/api/vacation-requests/LAB-001/rejection");
        message.Headers.Add("Origin", "https://audit.invalid");
        message.Content = new FormUrlEncodedContent([]);

        var response = await client.SendAsync(message);

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        var request = await client.GetFromJsonAsync<JsonElement>("/api/vacation-requests/LAB-001");
        Assert.Equal("Pending", request.GetProperty("status").GetString());
    }

    [Theory]
    [InlineData("https://audit.invalid")]
    [InlineData("http://localhost:9999")]
    [InlineData("null")]
    public async Task An_untrusted_origin_is_forbidden_even_with_the_laboratory_header(string origin)
    {
        using var client = _factory.CreateClient();
        client.DefaultRequestHeaders.Add("X-Laboratory-Request", "1");
        client.DefaultRequestHeaders.Add("Origin", origin);

        var response = await client.PostAsync("/api/vacation-requests/LAB-001/rejection", null);

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Theory]
    [InlineData("http://localhost:5173")]
    [InlineData("http://127.0.0.1:5173")]
    [InlineData("http://[::1]:5173")]
    public async Task The_local_frontend_can_reject_with_the_laboratory_header(string origin)
    {
        using var client = _factory.CreateClient();
        client.DefaultRequestHeaders.Add("X-Laboratory-Request", "1");
        client.DefaultRequestHeaders.Add("Origin", origin);

        var response = await client.PostAsync("/api/vacation-requests/LAB-001/rejection", null);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task A_non_loopback_host_is_rejected()
    {
        using var client = _factory.CreateClient();
        client.DefaultRequestHeaders.Host = "audit.invalid";

        var response = await client.GetAsync("/api/vacation-requests/LAB-001");

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Theory]
    [InlineData("127.0.0.1")]
    [InlineData("[::1]")]
    public async Task A_real_listener_binds_only_to_the_requested_loopback_address(string host)
    {
        var builder = WebApplication.CreateBuilder(new[] { "--urls", $"http://{host}:0" });
        LocalOnlyAccess.ConfigureListeners(builder);
        await using var app = builder.Build();
        app.MapGet("/", () => "laboratory");
        await app.StartAsync();

        var address = new Uri(Assert.Single(app.Urls));
        Assert.True(address.IsLoopback);
        Assert.Equal(host, address.Host);
        using var client = new HttpClient();
        Assert.Equal("laboratory", await client.GetStringAsync(address));
    }

    [Fact]
    public async Task A_write_without_the_header_is_forbidden_even_from_the_frontend_origin()
    {
        using var client = _factory.CreateClient();
        client.DefaultRequestHeaders.Add("Origin", "http://localhost:5173");

        var response = await client.PostAsync("/api/vacation-requests/LAB-001/rejection", null);

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }
}