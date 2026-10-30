using VacationManagement.Application;
using VacationManagement.Domain;

namespace VacationManagement.UnitTests.Application;

// AC-LAB-01..03 · UC-008 variante de laboratorio
public class VacationRequestServiceTests
{
    private readonly FakeRepository _repository = new();
    private readonly VacationRequestService _service;

    public VacationRequestServiceTests()
    {
        _repository.Add(new VacationRequest("LAB-001", "Persona Ficticia A", new DateOnly(2026, 7, 1), new DateOnly(2026, 7, 15), VacationRequestStatus.Pending));
        _service = new VacationRequestService(_repository);
    }

    [Fact]
    public async Task Get_existing_request_returns_its_data()
    {
        var result = await _service.GetAsync("LAB-001", CancellationToken.None);

        Assert.Equal(VacationRequestOutcome.Success, result.Outcome);
        Assert.Equal(new VacationRequestDto("LAB-001", "Persona Ficticia A", new DateOnly(2026, 7, 1), new DateOnly(2026, 7, 15), "Pending"), result.Request);
    }

    [Fact]
    public async Task Get_unknown_request_returns_not_found()
    {
        var result = await _service.GetAsync("NO-EXISTE", CancellationToken.None);

        Assert.Equal(VacationRequestOutcome.NotFound, result.Outcome);
        Assert.Null(result.Request);
    }

    [Fact]
    public async Task Reject_pending_request_saves_and_returns_rejected()
    {
        var result = await _service.RejectAsync("LAB-001", CancellationToken.None);

        Assert.Equal(VacationRequestOutcome.Success, result.Outcome);
        Assert.Equal("Rejected", result.Request!.Status);
        Assert.Equal(1, _repository.SaveCount);
        Assert.Equal(VacationRequestStatus.Rejected, _repository.Stored("LAB-001").Status);
    }

    [Fact]
    public async Task Reject_already_rejected_request_returns_not_pending_without_saving()
    {
        await _service.RejectAsync("LAB-001", CancellationToken.None);

        var result = await _service.RejectAsync("LAB-001", CancellationToken.None);

        Assert.Equal(VacationRequestOutcome.NotPending, result.Outcome);
        Assert.Equal("Rejected", result.Request!.Status);
        Assert.Equal(1, _repository.SaveCount);
    }

    [Fact]
    public async Task Reject_unknown_request_returns_not_found_without_saving()
    {
        var result = await _service.RejectAsync("NO-EXISTE", CancellationToken.None);

        Assert.Equal(VacationRequestOutcome.NotFound, result.Outcome);
        Assert.Null(result.Request);
        Assert.Equal(0, _repository.SaveCount);
    }

    [Fact]
    public void Constructor_requires_a_repository()
    {
        Assert.Throws<ArgumentNullException>(() => new VacationRequestService(null!));
    }

    [Fact]
    public void Dto_requires_a_request()
    {
        Assert.Throws<ArgumentNullException>(() => VacationRequestDto.From(null!));
    }

    private sealed class FakeRepository : IVacationRequestRepository
    {
        private readonly Dictionary<string, VacationRequest> _items = [];

        public int SaveCount { get; private set; }

        public void Add(VacationRequest request) => _items[request.Id] = request;

        public VacationRequest Stored(string id) => _items[id];

        public Task<VacationRequest?> FindAsync(string id, CancellationToken cancellationToken) =>
            Task.FromResult(_items.GetValueOrDefault(id));

        public Task SaveAsync(VacationRequest request, CancellationToken cancellationToken)
        {
            SaveCount++;
            _items[request.Id] = request;
            return Task.CompletedTask;
        }
    }
}
