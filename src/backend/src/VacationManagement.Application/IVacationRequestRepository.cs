using VacationManagement.Domain;

namespace VacationManagement.Application;

public interface IVacationRequestRepository
{
    Task<VacationRequest?> FindAsync(string id, CancellationToken cancellationToken);

    Task SaveAsync(VacationRequest request, CancellationToken cancellationToken);
}
