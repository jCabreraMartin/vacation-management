namespace VacationManagement.Domain;

public sealed class VacationRequestNotPendingException : InvalidOperationException
{
    public VacationRequestNotPendingException(string requestId)
        : base($"Vacation request '{requestId}' is not pending.")
    {
        RequestId = requestId;
    }

    public string RequestId { get; }
}
