using VacationManagement.Domain;

namespace VacationManagement.Application;

public sealed class VacationRequestService
{
    private static readonly VacationRequestResult NotFound = new(VacationRequestOutcome.NotFound, null);

    private readonly IVacationRequestRepository _repository;

    public VacationRequestService(IVacationRequestRepository repository)
    {
        ArgumentNullException.ThrowIfNull(repository);
        _repository = repository;
    }

    public async Task<VacationRequestResult> GetAsync(string id, CancellationToken cancellationToken)
    {
        var request = await _repository.FindAsync(id, cancellationToken).ConfigureAwait(false);
        return request is null
            ? NotFound
            : new VacationRequestResult(VacationRequestOutcome.Success, VacationRequestDto.From(request));
    }

    public async Task<VacationRequestResult> RejectAsync(string id, CancellationToken cancellationToken)
    {
        var request = await _repository.FindAsync(id, cancellationToken).ConfigureAwait(false);
        if (request is null)
        {
            return NotFound;
        }

        try
        {
            request.Reject();
            await _repository.SaveAsync(request, cancellationToken).ConfigureAwait(false);
        }
        catch (VacationRequestNotPendingException)
        {
            return new VacationRequestResult(VacationRequestOutcome.NotPending, VacationRequestDto.From(request));
        }

        return new VacationRequestResult(VacationRequestOutcome.Success, VacationRequestDto.From(request));
    }
}
