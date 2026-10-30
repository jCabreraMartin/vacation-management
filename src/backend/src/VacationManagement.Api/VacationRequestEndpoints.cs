using VacationManagement.Application;

namespace VacationManagement.Api;

public static class VacationRequestEndpoints
{
    public static IEndpointRouteBuilder MapVacationRequestEndpoints(this IEndpointRouteBuilder routes)
    {
        ArgumentNullException.ThrowIfNull(routes);

        var group = routes.MapGroup("/api/vacation-requests");

        group.MapGet("/{id}", async (string id, VacationRequestService service, CancellationToken cancellationToken) =>
            ToHttpResult(id, await service.GetAsync(id, cancellationToken).ConfigureAwait(false)));

        group.MapPost("/{id}/rejection", async (string id, VacationRequestService service, CancellationToken cancellationToken) =>
            ToHttpResult(id, await service.RejectAsync(id, cancellationToken).ConfigureAwait(false)));

        return routes;
    }

    private static IResult ToHttpResult(string id, VacationRequestResult result) => result.Outcome switch
    {
        VacationRequestOutcome.Success => Results.Ok(result.Request),
        VacationRequestOutcome.NotFound => Results.Problem(
            statusCode: StatusCodes.Status404NotFound,
            title: "Vacation request not found",
            detail: $"Vacation request '{id}' does not exist."),
        VacationRequestOutcome.NotPending => Results.Problem(
            statusCode: StatusCodes.Status409Conflict,
            title: "Vacation request is not pending",
            detail: $"Vacation request '{id}' is not pending and cannot be rejected."),
        _ => throw new InvalidOperationException($"Unsupported outcome '{result.Outcome}'."),
    };
}
