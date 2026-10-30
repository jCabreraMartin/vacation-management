namespace VacationManagement.Domain;

public sealed class VacationRequest
{
    public VacationRequest(string id, string personName, DateOnly startDate, DateOnly endDate, VacationRequestStatus status)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(id);
        ArgumentException.ThrowIfNullOrWhiteSpace(personName);

        Id = id;
        PersonName = personName;
        StartDate = startDate;
        EndDate = endDate;
        Status = status;
    }

    public string Id { get; }

    public string PersonName { get; }

    public DateOnly StartDate { get; }

    public DateOnly EndDate { get; }

    public VacationRequestStatus Status { get; private set; }

    // Only Pending -> Rejected is allowed; Rejected is terminal (DL-B1-03).
    public void Reject()
    {
        if (Status != VacationRequestStatus.Pending)
        {
            throw new VacationRequestNotPendingException(Id);
        }

        Status = VacationRequestStatus.Rejected;
    }
}
