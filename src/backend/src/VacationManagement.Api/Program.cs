using VacationManagement.Api;
using VacationManagement.Application;
using VacationManagement.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

LocalOnlyAccess.ConfigureListeners(builder);
builder.Services.AddProblemDetails();
builder.Services.AddSingleton<IVacationRequestRepository>(_ => InMemoryVacationRequestRepository.WithLaboratorySeed());
builder.Services.AddScoped<VacationRequestService>();

var app = builder.Build();

app.UseExceptionHandler();
app.UseLocalOnlyAccess();

app.MapVacationRequestEndpoints();

app.Run();

public partial class Program;
