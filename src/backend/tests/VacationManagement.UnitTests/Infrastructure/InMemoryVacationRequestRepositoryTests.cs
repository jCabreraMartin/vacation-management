using VacationManagement.Application;
using VacationManagement.Domain;
using VacationManagement.Infrastructure;

namespace VacationManagement.UnitTests.Infrastructure;

// DL-B1-04 / DL-B1-05
public class InMemoryVacationRequestRepositoryTests
{
    [Fact]
    public async Task Seeded_repository_contains_fictitious_pending_request()
    {
        var repository = InMemoryVacationRequestRepository.WithLaboratorySeed();

        var request = await repository.FindAsync("LAB-001", CancellationToken.None);

        Assert.NotNull(request);
        Assert.Equal("Persona Ficticia A", request.PersonName);
        Assert.Equal(VacationRequestStatus.Pending, request.Status);
    }

    [Fact]
    public void Seed_contains_only_fictitious_pending_requests()
    {
        foreach (var seeded in LaboratorySeedData.VacationRequests())
        {
            Assert.StartsWith("LAB-", seeded.Id, StringComparison.Ordinal);
            Assert.StartsWith("Persona Ficticia", seeded.PersonName, StringComparison.Ordinal);
            Assert.Equal(VacationRequestStatus.Pending, seeded.Status);
        }

        Assert.Equal(2, LaboratorySeedData.VacationRequests().Count);
    }

    [Fact]
    public async Task Find_unknown_id_returns_null()
    {
        var repository = InMemoryVacationRequestRepository.WithLaboratorySeed();

        Assert.Null(await repository.FindAsync("NO-EXISTE", CancellationToken.None));
    }

    [Fact]
    public async Task Saved_request_is_returned_by_later_find()
    {
        var repository = new InMemoryVacationRequestRepository([]);
        var request = new VacationRequest("LAB-900", "Persona Ficticia Z", new DateOnly(2026, 9, 1), new DateOnly(2026, 9, 2), VacationRequestStatus.Pending);
        request.Reject();

        await repository.SaveAsync(request, CancellationToken.None);

        var stored = await repository.FindAsync("LAB-900", CancellationToken.None);
        Assert.Equal(VacationRequestStatus.Rejected, stored!.Status);
    }

    [Fact]
    public async Task Each_repository_instance_starts_from_the_seed()
    {
        var first = InMemoryVacationRequestRepository.WithLaboratorySeed();
        var rejected = await first.FindAsync("LAB-001", CancellationToken.None);
        rejected!.Reject();
        await first.SaveAsync(rejected, CancellationToken.None);

        var second = InMemoryVacationRequestRepository.WithLaboratorySeed();

        Assert.Equal(VacationRequestStatus.Pending, (await second.FindAsync("LAB-001", CancellationToken.None))!.Status);
    }

    [Fact]
    public async Task Save_requires_a_request()
    {
        var repository = new InMemoryVacationRequestRepository([]);

        await Assert.ThrowsAsync<ArgumentNullException>(() => repository.SaveAsync(null!, CancellationToken.None));
    }

    [Fact]
    public void Constructor_requires_initial_requests()
    {
        Assert.Throws<ArgumentNullException>(() => new InMemoryVacationRequestRepository(null!));
    }

    [Fact]
    public async Task Changing_a_read_snapshot_does_not_change_storage_until_saved()
    {
        var repository = InMemoryVacationRequestRepository.WithLaboratorySeed();
        var snapshot = await repository.FindAsync("LAB-001", CancellationToken.None);

        snapshot!.Reject();

        Assert.Equal(VacationRequestStatus.Pending, (await repository.FindAsync("LAB-001", CancellationToken.None))!.Status);
    }

    [Fact]
    public async Task Concurrent_rejections_of_the_same_snapshot_have_one_success_and_one_conflict()
    {
        var repository = new CoordinatedRepository(InMemoryVacationRequestRepository.WithLaboratorySeed(), true);
        var service = new VacationRequestService(repository);

        var first = service.RejectAsync("LAB-001", CancellationToken.None);
        await repository.FirstRead.Task.WaitAsync(TimeSpan.FromSeconds(5));
        var second = service.RejectAsync("LAB-001", CancellationToken.None);
        var results = await Task.WhenAll(first, second).WaitAsync(TimeSpan.FromSeconds(5));

        Assert.Single(results, result => result.Outcome == VacationRequestOutcome.Success);
        Assert.Single(results, result => result.Outcome == VacationRequestOutcome.NotPending);
    }

    [Fact]
    public async Task A_blocked_request_does_not_block_rejection_of_another_id()
    {
        var repository = new CoordinatedRepository(InMemoryVacationRequestRepository.WithLaboratorySeed(), false);
        var service = new VacationRequestService(repository);
        var blocked = service.RejectAsync("LAB-001", CancellationToken.None);
        await repository.FirstRead.Task.WaitAsync(TimeSpan.FromSeconds(5));

        try
        {
            var other = await service.RejectAsync("LAB-002", CancellationToken.None).WaitAsync(TimeSpan.FromSeconds(5));
            Assert.Equal(VacationRequestOutcome.Success, other.Outcome);
            Assert.False(blocked.IsCompleted);
        }
        finally
        {
            repository.Release.TrySetResult();
            await blocked;
        }
    }

    private sealed class CoordinatedRepository(IVacationRequestRepository inner, bool releaseAfterBothReads) : IVacationRequestRepository
    {
        private int _reads;

        public TaskCompletionSource FirstRead { get; } = new(TaskCreationOptions.RunContinuationsAsynchronously);

        public TaskCompletionSource Release { get; } = new(TaskCreationOptions.RunContinuationsAsynchronously);

        public async Task<VacationRequest?> FindAsync(string id, CancellationToken cancellationToken)
        {
            var stored = await inner.FindAsync(id, cancellationToken);
            var snapshot = stored is null ? null : new VacationRequest(stored.Id, stored.PersonName, stored.StartDate, stored.EndDate, stored.Status);
            if (id == "LAB-001")
            {
                FirstRead.TrySetResult();
                if (Interlocked.Increment(ref _reads) == 2 && releaseAfterBothReads)
                {
                    Release.TrySetResult();
                }

                await Release.Task.WaitAsync(cancellationToken);
            }

            return snapshot;
        }

        public Task SaveAsync(VacationRequest request, CancellationToken cancellationToken) => inner.SaveAsync(request, cancellationToken);
    }
}
