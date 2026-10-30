using System.Collections.Concurrent;
using VacationManagement.Application;
using VacationManagement.Domain;

namespace VacationManagement.Infrastructure;

// Process-local storage (DL-B1-05): data is lost on restart and not shared between processes.
public sealed class InMemoryVacationRequestRepository : IVacationRequestRepository
{
    private readonly ConcurrentDictionary<string, VacationRequest> _requests;

    public InMemoryVacationRequestRepository(IEnumerable<VacationRequest> initialRequests)
    {
        ArgumentNullException.ThrowIfNull(initialRequests);
        _requests = new ConcurrentDictionary<string, VacationRequest>(
            initialRequests.Select(request => KeyValuePair.Create(request.Id, Copy(request))),
            StringComparer.Ordinal);
    }

    public static InMemoryVacationRequestRepository WithLaboratorySeed() =>
        new(LaboratorySeedData.VacationRequests());

    public Task<VacationRequest?> FindAsync(string id, CancellationToken cancellationToken)
    {
        var stored = _requests.GetValueOrDefault(id);
        return Task.FromResult(stored is null ? null : Copy(stored));
    }

    public Task SaveAsync(VacationRequest request, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(request);
        var replacement = Copy(request);
        if (_requests.TryGetValue(request.Id, out var stored))
        {
            if (stored.Status != VacationRequestStatus.Pending || !_requests.TryUpdate(request.Id, replacement, stored))
            {
                throw new VacationRequestNotPendingException(request.Id);
            }
        }
        else if (!_requests.TryAdd(request.Id, replacement))
        {
            throw new VacationRequestNotPendingException(request.Id);
        }

        return Task.CompletedTask;
    }

    private static VacationRequest Copy(VacationRequest request) =>
        new(request.Id, request.PersonName, request.StartDate, request.EndDate, request.Status);
}
