using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.DependencyInjection;
using VacationManagement.Application;
using VacationManagement.Domain;

namespace VacationManagement.IntegrationTests;

// UC-008 E-LAB-3: an internal failure must surface as Problem Details without internal details.
public sealed class UnexpectedErrorTests : IDisposable
{
    private const string InternalMessage = "storage unavailable";

    private readonly WebApplicationFactory<Program> _factory = new WebApplicationFactory<Program>()
        .WithWebHostBuilder(builder =>
        {
            builder.UseEnvironment("Production");
            builder.ConfigureServices(services =>
                services.AddSingleton<IVacationRequestRepository>(new FailingRepository()));
        });

    public void Dispose() => _factory.Dispose();

    [Fact]
    public async Task Repository_failure_returns_problem_500_without_internal_details()
    {
        using var client = _factory.CreateClient();
        client.DefaultRequestHeaders.Add("X-Laboratory-Request", "1");

        var response = await client.PostAsync(new Uri("/api/vacation-requests/LAB-001/rejection", UriKind.Relative), null);

        Assert.Equal(HttpStatusCode.InternalServerError, response.StatusCode);
        Assert.Equal("application/problem+json", response.Content.Headers.ContentType?.MediaType);
        var problem = await response.Content.ReadFromJsonAsync<JsonElement>();
        Assert.Equal(500, problem.GetProperty("status").GetInt32());
        Assert.DoesNotContain(InternalMessage, problem.GetRawText(), StringComparison.Ordinal);
    }

    private sealed class FailingRepository : IVacationRequestRepository
    {
        public Task<VacationRequest?> FindAsync(string id, CancellationToken cancellationToken) =>
            throw new InvalidOperationException(InternalMessage);

        public Task SaveAsync(VacationRequest request, CancellationToken cancellationToken) =>
            throw new InvalidOperationException(InternalMessage);
    }
}
