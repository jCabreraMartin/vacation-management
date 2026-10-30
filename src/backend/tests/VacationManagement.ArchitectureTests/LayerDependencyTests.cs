using System.Reflection;
using NetArchTest.Rules;
using VacationManagement.Application;
using VacationManagement.Domain;
using VacationManagement.Infrastructure;

namespace VacationManagement.ArchitectureTests;

// Laboratory layering (architecture-overview, Paso 16.2 Bolt 1): dependencies point towards Domain.
public class LayerDependencyTests
{
    private static readonly Assembly DomainAssembly = typeof(VacationRequest).Assembly;
    private static readonly Assembly ApplicationAssembly = typeof(VacationRequestService).Assembly;
    private static readonly Assembly InfrastructureAssembly = typeof(InMemoryVacationRequestRepository).Assembly;
    private static readonly Assembly ApiAssembly = typeof(Program).Assembly;

    public static TheoryData<string, string[]> ForbiddenDependencies => new()
    {
        { "Domain", ["VacationManagement.Application", "VacationManagement.Infrastructure", "VacationManagement.Api", "Microsoft.AspNetCore"] },
        { "Application", ["VacationManagement.Infrastructure", "VacationManagement.Api", "Microsoft.AspNetCore"] },
        { "Infrastructure", ["VacationManagement.Api", "Microsoft.AspNetCore"] },
    };

    [Theory]
    [MemberData(nameof(ForbiddenDependencies))]
    public void Layer_does_not_depend_on_outer_layers(string layer, string[] forbidden)
    {
        var result = Types.InAssembly(LayerAssembly(layer))
            .ShouldNot()
            .HaveDependencyOnAny(forbidden)
            .GetResult();

        Assert.True(result.IsSuccessful, $"{layer} violates layering: {string.Join(", ", result.FailingTypeNames ?? [])}");
    }

    [Theory]
    [InlineData("Domain")]
    [InlineData("Application")]
    [InlineData("Infrastructure")]
    [InlineData("Api")]
    public void Layer_assembly_is_not_empty(string layer)
    {
        Assert.NotEmpty(Types.InAssembly(LayerAssembly(layer)).GetTypes());
    }

    [Fact]
    public void Infrastructure_implements_application_port()
    {
        Assert.True(typeof(IVacationRequestRepository).IsAssignableFrom(typeof(InMemoryVacationRequestRepository)));
    }

    // Control: proves the dependency rules can detect a real dependency.
    [Fact]
    public void Dependency_check_detects_api_dependency_on_application()
    {
        var result = Types.InAssembly(ApiAssembly)
            .ShouldNot()
            .HaveDependencyOn("VacationManagement.Application")
            .GetResult();

        Assert.False(result.IsSuccessful);
    }

    private static Assembly LayerAssembly(string layer) => layer switch
    {
        "Domain" => DomainAssembly,
        "Application" => ApplicationAssembly,
        "Infrastructure" => InfrastructureAssembly,
        "Api" => ApiAssembly,
        _ => throw new ArgumentOutOfRangeException(nameof(layer), layer, null),
    };
}
