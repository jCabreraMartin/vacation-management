namespace VacationManagement.Application;

public enum VacationRequestOutcome
{
    Success,
    NotFound,
    NotPending,
}

public sealed record VacationRequestResult(VacationRequestOutcome Outcome, VacationRequestDto? Request);
