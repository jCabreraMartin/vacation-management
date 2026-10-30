using VacationManagement.Domain;

namespace VacationManagement.Infrastructure;

// Fictitious laboratory data (DL-B1-04); not sourced from any corporate system.
public static class LaboratorySeedData
{
    public static IReadOnlyList<VacationRequest> VacationRequests() =>
    [
        new("LAB-001", "Persona Ficticia A", new DateOnly(2026, 7, 1), new DateOnly(2026, 7, 15), VacationRequestStatus.Pending),
        new("LAB-002", "Persona Ficticia B", new DateOnly(2026, 8, 3), new DateOnly(2026, 8, 14), VacationRequestStatus.Pending),
    ];
}
