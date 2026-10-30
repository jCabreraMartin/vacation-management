using VacationManagement.Domain;

namespace VacationManagement.Application;

public sealed record VacationRequestDto(string Id, string PersonName, DateOnly StartDate, DateOnly EndDate, string Status)
{
    public static VacationRequestDto From(VacationRequest request)
    {
        ArgumentNullException.ThrowIfNull(request);
        return new(request.Id, request.PersonName, request.StartDate, request.EndDate, request.Status.ToString());
    }
}
