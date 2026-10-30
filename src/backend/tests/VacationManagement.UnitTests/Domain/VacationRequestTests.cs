using VacationManagement.Domain;

namespace VacationManagement.UnitTests.Domain;

// AC-LAB-01 / AC-LAB-02 · DL-B1-03
public class VacationRequestTests
{
    private static VacationRequest PendingRequest() =>
        new("LAB-001", "Persona Ficticia A", new DateOnly(2026, 7, 1), new DateOnly(2026, 7, 15), VacationRequestStatus.Pending);

    [Fact]
    public void Reject_pending_request_changes_status_to_rejected()
    {
        var request = PendingRequest();

        request.Reject();

        Assert.Equal(VacationRequestStatus.Rejected, request.Status);
    }

    [Fact]
    public void Reject_already_rejected_request_throws_and_keeps_status()
    {
        var request = PendingRequest();
        request.Reject();

        var error = Assert.Throws<VacationRequestNotPendingException>(request.Reject);

        Assert.Equal("LAB-001", error.RequestId);
        Assert.Contains("LAB-001", error.Message, StringComparison.Ordinal);
        Assert.Equal(VacationRequestStatus.Rejected, request.Status);
    }

    [Fact]
    public void New_request_keeps_its_data()
    {
        var request = PendingRequest();

        Assert.Equal("LAB-001", request.Id);
        Assert.Equal("Persona Ficticia A", request.PersonName);
        Assert.Equal(new DateOnly(2026, 7, 1), request.StartDate);
        Assert.Equal(new DateOnly(2026, 7, 15), request.EndDate);
        Assert.Equal(VacationRequestStatus.Pending, request.Status);
    }

    [Theory]
    [InlineData("")]
    [InlineData(" ")]
    public void New_request_requires_an_id(string id)
    {
        Assert.Throws<ArgumentException>(() =>
            new VacationRequest(id, "Persona Ficticia A", new DateOnly(2026, 7, 1), new DateOnly(2026, 7, 15), VacationRequestStatus.Pending));
    }

    [Theory]
    [InlineData("")]
    [InlineData(" ")]
    public void New_request_requires_a_person_name(string personName)
    {
        Assert.Throws<ArgumentException>(() =>
            new VacationRequest("LAB-001", personName, new DateOnly(2026, 7, 1), new DateOnly(2026, 7, 15), VacationRequestStatus.Pending));
    }
}
