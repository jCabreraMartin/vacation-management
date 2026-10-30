using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Testing;

namespace VacationManagement.IntegrationTests;

// AC-LAB-01..03 · contrato del Bolt 1 (#74). Cada prueba usa un host nuevo: el estado en memoria no se comparte.
public sealed class VacationRequestEndpointsTests : IDisposable
{
    private readonly WebApplicationFactory<Program> _factory = new();
    private readonly HttpClient _client;

    public VacationRequestEndpointsTests()
    {
        _client = _factory.CreateClient();
        _client.DefaultRequestHeaders.Add("X-Laboratory-Request", "1");
    }

    public void Dispose()
    {
        _client.Dispose();
        _factory.Dispose();
    }

    [Fact]
    public async Task Get_existing_request_returns_ok_with_its_data()
    {
        var response = await _client.GetAsync(new Uri("/api/vacation-requests/LAB-001", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var body = await response.Content.ReadFromJsonAsync<JsonElement>();
        Assert.Equal("LAB-001", body.GetProperty("id").GetString());
        Assert.Equal("Persona Ficticia A", body.GetProperty("personName").GetString());
        Assert.Equal("2026-07-01", body.GetProperty("startDate").GetString());
        Assert.Equal("2026-07-15", body.GetProperty("endDate").GetString());
        Assert.Equal("Pending", body.GetProperty("status").GetString());
    }

    [Fact]
    public async Task Get_unknown_request_returns_problem_404()
    {
        var response = await _client.GetAsync(new Uri("/api/vacation-requests/NO-EXISTE", UriKind.Relative));

        await AssertProblemAsync(response, HttpStatusCode.NotFound, "NO-EXISTE");
    }

    [Fact]
    public async Task Reject_pending_request_returns_rejected_and_persists()
    {
        var response = await _client.PostAsync(new Uri("/api/vacation-requests/LAB-001/rejection", UriKind.Relative), null);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var body = await response.Content.ReadFromJsonAsync<JsonElement>();
        Assert.Equal("Rejected", body.GetProperty("status").GetString());

        var reread = await _client.GetFromJsonAsync<JsonElement>(new Uri("/api/vacation-requests/LAB-001", UriKind.Relative));
        Assert.Equal("Rejected", reread.GetProperty("status").GetString());
    }

    [Fact]
    public async Task Reject_twice_returns_problem_409_and_keeps_rejected()
    {
        await _client.PostAsync(new Uri("/api/vacation-requests/LAB-001/rejection", UriKind.Relative), null);

        var response = await _client.PostAsync(new Uri("/api/vacation-requests/LAB-001/rejection", UriKind.Relative), null);

        await AssertProblemAsync(response, HttpStatusCode.Conflict, "LAB-001");
        var reread = await _client.GetFromJsonAsync<JsonElement>(new Uri("/api/vacation-requests/LAB-001", UriKind.Relative));
        Assert.Equal("Rejected", reread.GetProperty("status").GetString());
    }

    [Fact]
    public async Task Reject_unknown_request_returns_problem_404()
    {
        var response = await _client.PostAsync(new Uri("/api/vacation-requests/NO-EXISTE/rejection", UriKind.Relative), null);

        await AssertProblemAsync(response, HttpStatusCode.NotFound, "NO-EXISTE");
    }

    [Fact]
    public async Task Concurrent_rejections_return_one_ok_and_one_conflict()
    {
        var responses = await Task.WhenAll(
            _client.PostAsync(new Uri("/api/vacation-requests/LAB-001/rejection", UriKind.Relative), null),
            _client.PostAsync(new Uri("/api/vacation-requests/LAB-001/rejection", UriKind.Relative), null));

        Assert.Single(responses, response => response.StatusCode == HttpStatusCode.OK);
        Assert.Single(responses, response => response.StatusCode == HttpStatusCode.Conflict);
    }

    private static async Task AssertProblemAsync(HttpResponseMessage response, HttpStatusCode expected, string requestId)
    {
        Assert.Equal(expected, response.StatusCode);
        Assert.Equal("application/problem+json", response.Content.Headers.ContentType?.MediaType);
        var problem = await response.Content.ReadFromJsonAsync<JsonElement>();
        Assert.Equal((int)expected, problem.GetProperty("status").GetInt32());
        Assert.False(string.IsNullOrWhiteSpace(problem.GetProperty("title").GetString()));
        Assert.Contains(requestId, problem.GetProperty("detail").GetString(), StringComparison.Ordinal);
    }
}
