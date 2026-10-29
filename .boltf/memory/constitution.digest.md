# Resumen de la constitución

> Generado desde `merged-refinement.yaml` (2026-10-26 12:32:37). Ámbitos activos: backend, frontend y cloud-platform.
> Fuente canónica: `.boltf/memory/constitution.md`; consúltala para gobernanza, modificaciones o detalles omitidos aquí.
> Las decisiones aprobadas durante la inicialización que figuran a continuación son vinculantes. El contenido generado para cada ámbito puede conservar alternativas de plantilla sin refinar; no son vinculantes.

## Decisiones aprobadas durante la inicialización

- Proyecto greenfield y full-stack; ámbitos: backend, frontend y cloud-platform; gestión del trabajo: GitHub Projects.
- Backend: C# / .NET 8. Frontend: Vue.js (versión no especificada; sustituye a Angular, ADR-0004). Desarrollo local: Podman.
- Entornos: dev, uat y prod; pre deshabilitado. Archivos de configuración y User Secrets; sin feature flags.
- GitHub Actions; Terraform; despliegues rolling; GitHub Flow; todas las fases seleccionadas para los pipelines de aplicación e infraestructura.
- Umbrales: 80 % de cobertura unitaria y 60 % de puntuación de mutación.
- OpenTelemetry hacia Azure; Resource Health y Activity Logs.
- VNet, Private Endpoints, WAF, claves administradas por Azure y cifrado de PII; GDPR e HIPAA seleccionados en el asistente.
- Triggers del asistente: dev al hacer commit en `develop`, UAT al fusionar un PR y prod con aprobación manual. El trigger de dev contradice GitHub Flow; confirmarlo antes de implementarlo.
- El estilo de arquitectura y API, la base de datos, el proveedor de identidad y el modelo de autorización siguen sin decidirse.

## backend

### Article II — Application Configuration (HIGH)

#### Section 2.1: Backend Language & Runtime
Select ONE:
- ✔ **C# / .NET**
    - Version: ✔ .NET 8 (LTS) **(LOCKED for dotnet-8 template)**
  - API Style:
  - Version:
  - Framework:
  - Version:
  - Framework:
  - Version:
  - Framework:

### Article III — Application Architecture (HIGH)

#### Section 3.1: Backend Architecture Style
Select ONE:
#### Section 3.3: CQRS Configuration
CQRS Enabled:
If Yes, select pattern:
##### For C#/.NET: Native CQRS Interfaces (NO MediatR)
```csharp
// Commands
public interface ICommand { }
public interface ICommandHandler<in TCommand> where TCommand : ICommand
{
    Task HandleAsync(TCommand command, CancellationToken ct = default);
}
public interface ICommandHandler<in TCommand, TResult> where TCommand : ICommand
{
    Task<TResult> HandleAsync(TCommand command, CancellationToken ct = default);
}

// Queries
public interface IQuery<TResult> { }
public interface IQueryHandler<in TQuery, TResult> where TQuery : IQuery<TResult>
{
    Task<TResult> HandleAsync(TQuery query, CancellationToken ct = default);
}

// Dispatchers (DI-based, no reflection magic)
public interface ICommandDispatcher
{
    Task DispatchAsync<TCommand>(TCommand command, CancellationToken ct = default)
        where TCommand : ICommand;
}
public interface IQueryDispatcher
{
    Task<TResult> DispatchAsync<TQuery, TResult>(TQuery query, CancellationToken ct = default)
        where TQuery : IQuery<TResult>;
}

// Domain Events
public interface IDomainEvent
{
    Guid EventId { get; }
    DateTime OccurredOn { get; }
}
public interface IDomainEventHandler<in TEvent> where TEvent : IDomainEvent
{
    Task HandleAsync(TEvent domainEvent, CancellationToken ct = default);
}
```
##### For Node.js/TypeScript: Native CQRS Pattern
```typescript
// Commands
interface ICommand {}
interface ICommandHandler<TCommand extends ICommand, TResult = void> {
  handle(command: TCommand): Promise<TResult>;
}

// Queries
interface IQuery<TResult> {}
interface IQueryHandler<TQuery extends IQuery<TResult>, TResult> {
  handle(query: TQuery): Promise<TResult>;
}

// Bus (simple DI-based)
interface ICommandBus {
  dispatch<TCommand extends ICommand>(command: TCommand): Promise<void>;
}
interface IQueryBus {
  dispatch<TQuery extends IQuery<TResult>, TResult>(query: TQuery): Promise<TResult>;
}

// Domain Events
interface IDomainEvent {
  eventId: string;
  occurredOn: Date;
}
interface IDomainEventHandler<TEvent extends IDomainEvent> {
  handle(event: TEvent): Promise<void>;
}
```
#### Section 3.4: Event Sourcing Configuration
Event Sourcing Enabled:
If Yes, select Event Store:

### Article IV — Communication (HIGH)

#### Section 4.1: Communication Style
Select ONE:
#### Section 4.2: Synchronous Communication
#### Section 4.3: Asynchronous Communication
Message Broker - Select ONE:  (if async)
Background Processing - Select ONE or more:

### Article V — Data Storage (HIGH)

#### Section 5.1: Primary Database
Select ONE:
#### Section 5.2: Data Access Pattern
##### For C#/.NET
##### For Node.js/TypeScript
##### For Python
##### For Go
Repository Pattern:
Unit of Work Pattern:
#### Section 5.3: Database Migrations
##### For C#/.NET
##### For Node.js/TypeScript
##### For Python
##### For Go

### Article VII — Identity & Access Management (HIGH)

#### Section 7.1: Identity Provider (Production)
Select ONE:
#### Section 7.2: Identity Provider (Development/Testing)
Select ONE:
#### Section 7.3: Authentication Flows
| Scenario           | Flow                      | Enabled        |
| ------------------ | ------------------------- | -------------- |
| SPA Frontend       | Authorization Code + PKCE |
| Mobile App         | Authorization Code + PKCE |
| Service-to-Service | Client Credentials        |
| Backend API        | JWT Bearer Validation     |
#### Section 7.4: Authorization Model
Select ONE:

### Article VI — Caching Strategy (MEDIUM)

#### Section 6.1: Cache Levels  (Enabled) /  (TTL values)
| Level                | Technology                                 | Enabled        | TTL Default    |
| -------------------- | ------------------------------------------ | -------------- | -------------- |
| **L1 - In-Memory**   | IMemoryCache (.NET) / node-cache (Node.js) / cachetools (Python) / patrickmn/go-cache (Go) |
| **L2 - Distributed** | (see below)                                |
| **L3 - CDN**         | (see below)                                |
#### Section 6.2: Distributed Cache (L2)
Select ONE:
#### Section 6.3: CDN (L3)
Select ONE:
#### Section 6.4: Cache Patterns

### Article XIII — Testing Standards (MEDIUM)

#### Section 13.1: Testing Philosophy  (thresholds are configurable)
| Metric          | Minimum | Recommended | Tool                                 |
| --------------- | ------- | ----------- | ------------------------------------ |
| Line Coverage   | >= 80%  | >= 90%      | coverlet (.NET) / istanbul (Node.js) / pytest-cov (Python) / go test -cover (Go) |
| Branch Coverage | >= 75%  | >= 85%      | coverlet (.NET) / istanbul (Node.js) / coverage.py (Python) / go tool cover (Go) |
| Mutation Score  | >= 70%  | >= 80%      | Stryker.NET / Stryker Mutator / mutmut or cosmic-ray (Python) / go-mutesting (Go) |
#### Section 13.2: Testing Frameworks
##### For C#/.NET
| Type               | Framework              |
| ------------------ | ---------------------- |
| Unit Tests         | xUnit                  |
| Integration Tests  | xUnit + Testcontainers |
| Architecture Tests | NetArchTest            |
| BDD/Gherkin        | SpecFlow / Reqnroll    |
| E2E Tests          | Playwright             |
| Performance Tests  | NBomber / k6           |
##### For Node.js/TypeScript
| Type               | Framework             |
| ------------------ | --------------------- |
| Unit Tests         | Jest / Vitest         |
| Integration Tests  | Jest + Testcontainers |
| Architecture Tests | dependency-cruiser    |
| BDD/Gherkin        | Cucumber.js           |
| E2E Tests          | Playwright / Cypress  |
| Performance Tests  | k6 / Artillery        |
##### For Python
| Type               | Framework                              |
| ------------------ | -------------------------------------- |
| Unit Tests         | pytest                                 |
| Integration Tests  | pytest + Testcontainers                |
| Architecture Tests | import-linter / pytest-archon          |
| BDD/Gherkin        | Behave / pytest-bdd                    |
| E2E Tests          | Playwright                             |
| Performance Tests  | k6 / Locust                            |
##### For Go
| Type               | Framework                              |
| ------------------ | -------------------------------------- |
| Unit Tests         | testing (stdlib) + testify             |
| Integration Tests  | testing + Testcontainers               |
| Architecture Tests | depguard / custom package boundary tests |
| BDD/Gherkin        | godog                                  |
| E2E Tests          | Playwright                             |
| Performance Tests  | k6 / vegeta                            |
#### Section 13.3: Test Project Structure
##### For C#/.NET
##### For Node.js/TypeScript
##### For Python
##### For Go

### Article XIV — Code Standards (MEDIUM)

#### Section 14.1: Naming Conventions
##### For C#/.NET
| Element        | Convention     | Example                      |
| -------------- | -------------- | ---------------------------- |
| Namespaces     | PascalCase     | `MyCompany.MyProject.Domain` |
| Classes        | PascalCase     | `OrderService`               |
| Interfaces     | I + PascalCase | `IOrderService`              |
| Methods        | PascalCase     | `GetOrderByIdAsync`          |
| Properties     | PascalCase     | `OrderId`                    |
| Private fields | \_camelCase    | `_orderRepository`           |
| Async methods  | Suffix Async   | `GetOrderByIdAsync`          |
##### For Node.js/TypeScript
| Element    | Convention       | Example            |
| ---------- | ---------------- | ------------------ |
| Files      | kebab-case       | `order-service.ts` |
| Classes    | PascalCase       | `OrderService`     |
| Interfaces | I + PascalCase   | `IOrderService`    |
| Functions  | camelCase        | `getOrderById`     |
| Variables  | camelCase        | `orderId`          |
| Constants  | UPPER_SNAKE_CASE | `MAX_RETRIES`      |
##### For Python
| Element     | Convention     | Example            |
| ----------- | -------------- | ------------------ |
| Modules     | snake_case     | `order_service.py` |
| Classes     | PascalCase     | `OrderService`     |
| Functions   | snake_case     | `get_order_by_id`  |
| Variables   | snake_case     | `order_id`         |
| Constants   | UPPER_SNAKE_CASE | `MAX_RETRIES`    |
##### For Go
| Element     | Convention     | Example            |
| ----------- | -------------- | ------------------ |
| Packages    | lower-case     | `orders`           |
| Files       | snake_case     | `order_service.go` |
| Exported    | PascalCase     | `OrderService`     |
| Unexported  | camelCase      | `orderService`     |
| Constants   | PascalCase / UPPER_SNAKE_CASE | `MaxRetries` |
#### Section 14.2: Code Formatting
##### For C#/.NET
| Setting                  | Value                                  |
| ------------------------ | -------------------------------------- |
| Indentation              | 4 spaces                               |
| Line Length              | 120 characters                         |
| File-scoped namespaces   |
| Nullable reference types |
| Tooling                  | .editorconfig + dotnet format          |
##### For Node.js/TypeScript
| Setting     | Value                 |
| ----------- | --------------------- |
| Indentation | 2 spaces              |
| Line Length | 100 characters        |
| Semicolons  |
| Quotes      |
| Tooling     | ESLint + Prettier     |
##### For Python
| Setting     | Value                 |
| ----------- | --------------------- |
| Indentation | 4 spaces              |
| Line Length | 88-100 characters     |
| Type Hints  |
| Tooling     | Ruff + Black + isort  |
##### For Go
| Setting     | Value                 |
| ----------- | --------------------- |
| Indentation | tabs (gofmt)          |
| Line Length | gofmt default         |
| Error Style | explicit errors       |
| Tooling     | gofmt + golangci-lint |

### Article XVI — Security Policies (MEDIUM)

#### Section 16.1: Network Security
| Component                | Configuration                     |
| ------------------------ | --------------------------------- |
| Virtual Network          |
| Private Endpoints        |
| Web Application Firewall |
#### Section 16.2: Data Protection
| Policy                | Value                                                 |
| --------------------- | ----------------------------------------------------- |
| Encryption at Rest    | ✔ Azure-managed keys
| Encryption in Transit | TLS 1.2+ (mandatory)                                  |
| PII Handling          | ✔ Pseudonymization
#### Section 16.3: Compliance Requirements
| Standard | Required       |
| -------- | -------------- |
| GDPR     |
| HIPAA    |
| SOC 2    |
| PCI-DSS  |

### Article XVII — Legacy & Migration (MEDIUM)

#### Section 17.1: Migration Context
Select ONE:
#### Section 17.2: Migration Strategy (if applicable)
Select ONE:

### Article VIII — Containers & Orchestration (LOW)

#### Section 8.1: Container Strategy
#### Section 8.2: Orchestration Platform
#### Section 8.3: Kubernetes Configuration (if AKS/K8s selected)
#### Section 8.4: Cloud-Native Extensions
##### KEDA (Kubernetes Event-Driven Autoscaling)
##### Dapr (Distributed Application Runtime)
| Building Block     | Enabled        | Azure Component                      |
| ------------------ | -------------- | ------------------------------------ |
| Service Invocation |
| State Management   |
| Pub/Sub            |
| Secrets            |

### Article X — Environments & Configuration (LOW)

#### Section 10.1: Environment Strategy
| Environment | Purpose                      | Enabled | Auto-Deploy              |
| ----------- | ---------------------------- | ------- | ------------------------ |
| **dev**     | Development, rapid iteration |
| **uat**     | User Acceptance Testing      |
| **pre**     | Pre-production, staging      |
| **prod**    | Production                   |
#### Section 10.2: Configuration Management
#### Section 10.3: Secrets Management
| Secret Type        | Storage         |
| ------------------ | --------------- |
| Connection Strings | Azure Key Vault |
| API Keys           | Azure Key Vault |
| Certificates       | Azure Key Vault |
#### Section 10.4: Feature Flags

### Article XI — CI/CD Pipeline (LOW)

#### Section 11.1: CI/CD Platform
#### Section 11.2: Pipeline Stages
##### For Application Development
| Stage                  | Enabled | Threshold                          |
| ---------------------- | ------- | ---------------------------------- |
| **Build**              | ✔ Yes | Warnings as errors: ✔ Yes
| **Lint/Format**        |
| **Unit Tests**         |
| **Integration Tests**  |
| **Architecture Tests** |
| **Mutation Tests**     |
| **Security Scan**      |
| **Container Build**    |
| **Container Scan**     |
##### Deployment Stages
| Stage           | Enabled | Trigger            |
| --------------- | ------- | ------------------ |
| **Deploy Dev**  | ✔ Yes | Auto on pull request |
| **Deploy UAT**  | ✔ Yes | Auto on main         |
| **Deploy Pre**  | ✔ Yes | Manual trigger     |
| **Deploy Prod** | ✔ Yes | Manual approval    |
#### Section 11.3: Deployment Strategy
#### Section 11.4: Branch Strategy
- ✔ **GitHub Flow** (default; see `../../branching-strategy.md` for naming and lifecycle)

### Article XII — Observability (LOW)

#### Section 12.1: Observability Strategy
#### Section 12.2: Health Checks

### Article XV — Project Structure Templates (LOW)

#### Template A: C# + Modular Monolith
#### Template B: C# + Microservices
#### Template C: Node.js + Modular Monolith
#### Template D: Node.js + Microservices
#### Template E: Python/FastAPI + Modular Monolith
#### Template F: Go + Microservices

### Article XVIII — API Management (LOW)

#### Section 18.1: API Gateway
#### Section 18.2: API Features
| Feature        | Enabled        | Configuration                |
| -------------- | -------------- | ---------------------------- |
| Rate Limiting  |
| API Versioning |
#### Section 18.3: API Documentation
| Type         | Tool              | Enabled        |
| ------------ | ----------------- | -------------- |
| REST API     | OpenAPI / Swagger |
| Async Events | AsyncAPI          |

### Article XIX — Governance (LOW)

- Governance: amendments via ADR; AI agents MUST comply with this constitution (see constitution.md).
## frontend

### Article II — Application Configuration (HIGH)

#### Section 2.2: Frontend Framework
Select ONE:
#### Section 2.3: Mobile Application
Select ONE:
#### Section 2.4: Design Tooling 🆕
Select ONE visual design tool integration:
  `.boltf/scripts/powershell/Install-Penpot.ps1` / `.boltf/scripts/bash/install-penpot.sh`
  (Podman by default). MCP wired
  to the local instance; design tokens exported to `tokens.css`.
  (`https://<domain>`). Provide instance URL + MCP key; no local install.
  Penpot MCP, no token pipeline.
##### Design Gate (DISCOVERY → PLAN)
Before `bolt-plan` produces the technical plan for a UI feature, an **approved Penpot
design** must exist that covers the required UI states (`default`, `empty`, `loading`,
`error`, `success` per the `bolt-ui-mockups` matrix). The `bolt-penpot` agent in
`validate` mode writes the evidence to `specs/[XXX-feature-name]/design/penpot-validate.md`.
- ✅ Gate passes → `bolt-plan` proceeds.
- ⛔ No approved design / missing states → `bolt-plan` warns and routes back to
  `bolt-penpot` (or `bolt-mockup` for low-fi) before planning.
- When `design-tool = none`, this gate is inactive (HTML mockups remain the artifact).

### Article III — Application Architecture (HIGH)

#### Section 3.2: Frontend Architecture Style
Select ONE:

### Article VII — Identity & Access Management (Frontend) (MEDIUM)

#### Section 7.3: Authentication Flows
| Scenario     | Flow                      | Enabled        |
| ------------ | ------------------------- | -------------- |
| SPA Frontend | Authorization Code + PKCE |
| Mobile App   | Authorization Code + PKCE |
#### Section 7.4: Authorization Model
Select ONE:

### Article X — Environments & Configuration (MEDIUM)

#### Section 10.1: Environment Strategy
| Environment | Purpose                      | Enabled | Auto-Deploy              |
| ----------- | ---------------------------- | ------- | ------------------------ |
| **dev**     | Development, rapid iteration |
| **uat**     | User Acceptance Testing      |
| **pre**     | Pre-production, staging      |
| **prod**    | Production                   |
#### Section 10.2: Configuration Management
Select strategy:
#### Section 10.3: Secrets Management
| Secret Type        | Storage         |
| ------------------ | --------------- |
| Connection Strings | Azure Key Vault |
| API Keys           | Azure Key Vault |
| Certificates       | Azure Key Vault |
Local Development Secrets:
#### Section 10.4: Feature Flags
Feature Flag Provider:

### Article XI — CI/CD Pipeline (MEDIUM)

#### Section 11.1: CI/CD Platform
Select ONE:
#### Section 11.2: Pipeline Stages
##### For Application Development
| Stage                  | Enabled | Threshold                          |
| ---------------------- | ------- | ---------------------------------- |
| **Build**              |
| **Lint/Format**        |
| **Unit Tests**         |
| **Integration Tests**  |
| **Architecture Tests** |
| **Mutation Tests**     |
| **Security Scan**      |
| **Container Build**    |
| **Container Scan**     |
##### Deployment Stages
| Stage           | Enabled | Trigger            |
| --------------- | ------- | ------------------ |
| **Deploy Dev**  |
| **Deploy UAT**  |
| **Deploy Pre**  |
| **Deploy Prod** |
#### Section 11.3: Deployment Strategy
Select ONE:
#### Section 11.4: Branch Strategy
Select ONE:

### Article XII — Observability (MEDIUM)

#### Section 12.1: Observability Strategy
Select ONE:
#### Section 12.2: Health Checks

### Article XIII — Testing Standards (Frontend) (LOW)

#### Section 13.1: Testing Philosophy
| Metric          | Minimum | Recommended | Tool               |
| --------------- | ------- | ----------- | ------------------ |
| Line Coverage   | >= 80%  | >= 90%      | istanbul (Node.js) |
| Branch Coverage | >= 75%  | >= 85%      | istanbul (Node.js) |
| Mutation Score  | >= 70%  | >= 80%      | Stryker Mutator    |
#### Section 13.2: Testing Frameworks (Frontend)
| Type              | Framework                           |
| ----------------- | ----------------------------------- |
| Unit Tests        | Jest / Vitest                       |
| Component Tests   | Testing Library (React/Vue/Angular) |
| E2E Tests         | Playwright / Cypress                |
| Visual Regression | Playwright / Chromatic              |
| Performance Tests | Lighthouse CI / Web Vitals          |

### Article XIV — Code Standards (LOW)

#### Section 14.1: Naming Conventions
##### For Node.js/TypeScript (Frontend)
| Element    | Convention       | Example            |
| ---------- | ---------------- | ------------------ |
| Files      | kebab-case       | `order-service.ts` |
| Components | PascalCase       | `OrderDetail.tsx`  |
| Interfaces | I + PascalCase   | `IOrderService`    |
| Functions  | camelCase        | `getOrderById`     |
| Variables  | camelCase        | `orderId`          |
| Constants  | UPPER_SNAKE_CASE | `MAX_RETRIES`      |
#### Section 14.2: Code Formatting
| Setting     | Value                 |
| ----------- | --------------------- |
| Indentation | 2 spaces              |
| Line Length | 100 characters        |
| Semicolons  |
| Quotes      |
| Tooling     | ESLint + Prettier     |

### Article XVI — Security Policies (LOW)

#### Section 16.1: Network Security
| Component                | Configuration                     |
| ------------------------ | --------------------------------- |
| Virtual Network          |
| Private Endpoints        |
| Web Application Firewall |
#### Section 16.2: Data Protection
| Policy                | Value                                                 |
| --------------------- | ----------------------------------------------------- |
| Encryption at Rest    |
| Encryption in Transit | TLS 1.2+ (mandatory)                                  |
| PII Handling          |
#### Section 16.3: Compliance Requirements
| Standard | Required       |
| -------- | -------------- |
| GDPR     |
| HIPAA    |
| SOC 2    |
| PCI-DSS  |

### Article XVII — Legacy & Migration (LOW)

#### Section 17.1: Migration Context
#### Section 17.2: Migration Strategy (if applicable)

### Article XIX — Governance (LOW)

- Governance: amendments via ADR; AI agents MUST comply with this constitution (see constitution.md).

## cloud-platform

### Article VIII — Containers & Orchestration (HIGH)

#### Section 8.1: Container Strategy
#### Section 8.2: Orchestration Platform
Select ONE:
#### Section 8.3: Kubernetes Configuration (if AKS/K8s selected)
Package Manager:
Ingress Controller:
#### Section 8.4: Cloud-Native Extensions
##### KEDA (Kubernetes Event-Driven Autoscaling)
KEDA Enabled:
If Yes, select scalers:
##### Dapr (Distributed Application Runtime)
Dapr Enabled:
If Yes, select building blocks:
| Building Block     | Enabled        | Azure Component                      |
| ------------------ | -------------- | ------------------------------------ |
| Service Invocation |
| State Management   |
| Pub/Sub            |
| Secrets            |

### Article VIII-B — Infrastructure Scope & Landing Zone Strategy (HIGH)

#### Section 8B.1: Infrastructure Scope
Select infrastructure provisioning scope:
#### Section 8B.2: Landing Zone Components (if Landing Zone selected)
**Core Components**:
**Implementation Pattern**:
**Networking Model**:
#### Section 8B.3: Workload Infrastructure Components (if Workload or Both selected)
**Compute Resources**:
**Data Resources**:
**Integration Resources**:
#### Section 8B.4: Deployment Strategy
**Provisioning Order** (if Both selected):
1. Landing Zone foundation (management, networking, governance)
2. Workload-specific subscriptions
3. Application resources
**Separation of Concerns**:
#### Section 8B.5: Trade-offs and Rationale
**Landing Zone Benefits**:
- ✅ Enterprise governance at scale
- ✅ Consistent security baseline
- ✅ Centralized networking (ExpressRoute, VPN)
- ✅ Multi-subscription architecture support
**Landing Zone Costs**:
- ⚠️ Increased complexity (Management Groups, policies)
- ⚠️ Longer initial setup time
- ⚠️ Requires platform engineering expertise
**Workload-Only Benefits**:
- ✅ Faster time-to-market (assumes platform exists)
- ✅ Focused scope (app-specific resources only)
- ✅ Simpler IaC (no cross-subscription dependencies)
**Workload-Only Assumptions**:
- ⚠️ Assumes existing landing zone or shared platform
- ⚠️ Limited control over networking/governance
- ⚠️ May require coordination with platform team

### Article IX — Infrastructure as Code (HIGH)

#### Section 9.1: IaC Tool
Select ONE:
#### Section 9.2: IaC Structure
```text
infra/
├── bicep/                      # or terraform/
│   ├── modules/
│   │   ├── networking/
│   │   ├── compute/
│   │   ├── data/
│   │   └── security/
│   ├── environments/
│   │   ├── dev.bicepparam
│   │   ├── uat.bicepparam
│   │   ├── pre.bicepparam
│   │   └── prod.bicepparam
│   └── main.bicep
├── k8s/                        # If using Kubernetes
│   ├── helm/
│   └── kustomize/
└── scripts/
    └── deploy.ps1
```
#### Section 9.3: Landing Zone Configuration
Landing Zone Pattern:
##### If CAF Enterprise-Scale
| Component                  | Enabled                       | Notes                                                |
| -------------------------- | ----------------------------- | ---------------------------------------------------- |
| Management Group Hierarchy |
| Connectivity               |
| Identity                   |
| Management                 |
| Security                   |
##### Governance Components
| Policy                   | Enabled        | Scope                             |
| ------------------------ | -------------- | --------------------------------- |
| Azure Policy Initiatives |
| Azure RBAC Custom Roles  |
| Azure Blueprints         |
| Cost Management Budgets  |
| Resource Tags            |
##### Landing Zone Structure (Bicep)
```text
infra/
├── platform/
│   ├── management-groups/
│   │   └── main.bicep
│   ├── policies/
│   │   ├── initiatives/
│   │   └── assignments/
│   ├── connectivity/
│   │   ├── hub-network.bicep
│   │   ├── dns-zones.bicep
│   │   └── firewall.bicep
│   ├── identity/
│   │   └── main.bicep
│   └── management/
│       ├── log-analytics.bicep
│       └── automation.bicep
├── landing-zones/
│   ├── templates/
│   │   ├── corp/           # Internal workloads
│   │   └── online/         # Public-facing workloads
│   └── subscriptions/
│       └── {workload-name}/
└── scripts/
    ├── deploy-platform.ps1
    └── deploy-landing-zone.ps1
```

### Article VIII-C — Service Orchestration with .NET Aspire (MEDIUM)

#### Section 8C.1: Aspire Adoption Decision
**Choose ONE**:
#### Section 8C.2: Aspire Components (if Yes)
When Aspire is enabled, the following components are provisioned:
- **AppHost Project**: Orchestrator that defines service topology and dependencies
- **ServiceDefaults Library**: Shared OpenTelemetry, health checks, and resilience configuration
- **Service Discovery**: Automatic resolution via `WithReference()` API
- **Aspire Dashboard**: Local observability dashboard at `http://localhost:15888`
#### Section 8C.3: Service Discovery Strategy
**Choose ONE**:
#### Section 8C.4: Rationale and Trade-offs
**✅ When to Use Aspire**:
- Multi-service .NET architecture (backend + frontend + API gateway)
- Team wants unified local development experience (`dotnet run` launches all)
- Observability is a priority (OpenTelemetry out-of-the-box)
- Deploying to Azure with `azd` CLI
**❌ When NOT to Use**:
- Single-service application (no orchestration needed)
- Non-.NET services (Node.js, Python, Go) - Aspire is .NET-centric
- Team prefers explicit configuration over "magic" service discovery
- Docker Desktop unavailable (Aspire requires containers for local dev)
**Benefits**:
- ✅ **Automatic Service Discovery**: Eliminates hardcoded URLs between services
- ✅ **Built-in Observability**: OpenTelemetry dashboard for traces, metrics, logs
- ✅ **Simplified Local Development**: Single `dotnet run` launches all services
- ✅ **Unified Deployment**: `azd up` deploys entire solution to Azure with Bicep generation
**Costs & Constraints**:
- ⚠️ **Docker Desktop Required**: Aspire runs services in containers locally
- ⚠️ **Learning Curve**: AppHost model and `WithReference()` API
- ⚠️ **.NET 8+ Required**: Aspire is not available for older frameworks
- ⚠️ **Additional Project**: AppHost adds complexity to solution structure
#### Section 8C.5: Implementation References
**Provisioning**:
- Article VIII-C decisions are processed by `@Bolt Constitution` agent
- Templates downloaded from [dotnet/aspire GitHub](https://github.com/dotnet/aspire/tree/main/templates)
- AppHost project created at `src/AppHost/`
- ServiceDefaults library created at `src/ServiceDefaults/`
**Learn More**:
- [.NET Aspire Documentation](https://learn.microsoft.com/dotnet/aspire/)
- [AppHost Patterns](https://learn.microsoft.com/dotnet/aspire/fundamentals/app-host-overview)
- [Service Discovery Overview](https://learn.microsoft.com/dotnet/aspire/service-discovery/overview)
- Skill: `skill-bolt-aspire-orchestration` (provisioned if enabled)

### Article X — Environments & Configuration (LOW)

#### Section 10.1: Environment Strategy
| Environment | Purpose                      | Enabled | Auto-Deploy              |
| ----------- | ---------------------------- | ------- | ------------------------ |
| **dev**     | Development, rapid iteration |
| **uat**     | User Acceptance Testing      |
| **pre**     | Pre-production, staging      |
| **prod**    | Production                   |
#### Section 10.2: Configuration Management
#### Section 10.3: Secrets Management
| Secret Type        | Storage         |
| ------------------ | --------------- |
| Connection Strings | Azure Key Vault |
| API Keys           | Azure Key Vault |
| Certificates       | Azure Key Vault |
#### Section 10.4: Feature Flags

### Article XI — CI/CD Pipeline (LOW)

#### Section 11.1: CI/CD Platform
#### Section 11.2: Pipeline Stages
##### For Infrastructure
| Stage                | Enabled | Threshold           |
| -------------------- | ------- | ------------------- |
| **IaC Lint**         |
| **IaC Validation**   |
| **Security Scan**    |
| **Cost Estimation**  |
| **Compliance Check** |
##### Deployment Stages
| Stage           | Enabled | Trigger            |
| --------------- | ------- | ------------------ |
| **Deploy Dev**  |
| **Deploy UAT**  |
| **Deploy Pre**  |
| **Deploy Prod** |
#### Section 11.3: Deployment Strategy
#### Section 11.4: Branch Strategy

### Article XII — Observability (LOW)

#### Section 12.1: Observability Strategy
#### Section 12.2: Health Checks
#### Section 12.3: Infrastructure Monitoring (if Infrastructure scope)
| Component       | Tool                      | Enabled |
| --------------- | ------------------------- | ------- |
| Resource Health | Azure Resource Health     |
| Activity Logs   | Azure Monitor             |
| Diagnostics     | Log Analytics             |
| Alerts          | Azure Monitor Alerts      |
| Dashboards      | Azure Workbooks / Grafana |

### Article XIII — Testing Standards (Infrastructure) (LOW)

#### Section 13.4: Infrastructure Testing (if Infrastructure scope)
| Test Type         | Tool                   | Purpose                    |
| ----------------- | ---------------------- | -------------------------- |
| IaC Lint          | Bicep linter / tflint  | Syntax and best practices  |
| Security Scan     | Checkov / tfsec        | Security misconfigurations |
| Policy Compliance | Azure Policy (what-if) | Governance validation      |
| Integration Test  | Pester / Terratest     | Post-deployment validation |
| Cost Estimation   | Infracost              | Budget validation          |

### Article XV — Project Structure Templates (Infrastructure) (LOW)

#### Template E: Infrastructure Only - Landing Zone
#### Template F: Infrastructure Only - Workload

### Article XIV — GitOps & Declarative Deployment (LOW)

**GitOps** is a declarative approach to continuous delivery where Git is the single source of truth for infrastructure and application configurations. Git commits trigger automated deployments without manual kubectl/helm commands.
#### Section 14.1: GitOps Tool Selection
**Comparison**:
| Feature               | Flux                    | ArgoCD                         | Manual      |
| --------------------- | ----------------------- | ------------------------------ | ----------- |
| **Azure Integration** | ✅ Native (AKS, Arc)    | ⚠️ Requires setup              | ❌ N/A      |
| **UI**                | ⚠️ Basic (Flux UI)      | ✅ Advanced web UI             | ❌ CLI only |
| **Helm Support**      | ✅ Native               | ✅ Native                      | ✅ CLI      |
| **Image Automation**  | ✅ Flux Image Reflector | ⚠️ Requires Argo Image Updater | ❌ Manual   |
| **Multi-Tenancy**     | ⚠️ Namespace-based      | ✅ App Projects                | ❌ N/A      |
| **Learning Curve**    | Medium                  | Medium-High                    | Low         |
**Recommendation**: Use Flux for Azure-native teams (AKS Extension), ArgoCD if advanced UI/RBAC required.
#### Section 14.2: GitOps Repository Structure
**Mono-Repo vs Multi-Repo**:
  - **Pro**: Simplified management, atomic changes across components
  - **Con**: Larger blast radius, all teams see all configs
  - **Pro**: Granular access control, smaller blast radius
  - **Con**: Complex cross-repo dependencies, harder to coordinate changes
**Recommended Structure (Mono-Repo with Flux)**:
#### Section 14.3: Deployment Strategy
**Git Workflow**:
**Promotion Strategy**:
#### Section 14.4: Flux Configuration (if Flux selected)
**Flux Components**:
- **Source Controller** - Monitors Git repos, Helm repos, S3 buckets
- **Kustomize Controller** - Applies Kustomize manifests
- **Helm Controller** - Deploys Helm charts
- **Notification Controller** - Sends alerts (Slack, Teams, email)
- **Image Reflector/Automation** - Scans ACR for new images, auto-updates Git
**Bootstrap Flux on AKS**:
**Example GitRepository Source**:
**Example Kustomization**:
#### Section 14.5: Image Automation (Flux Only)
**Automated Image Updates** - Flux scans ACR for new images matching policy, updates Git manifests.
#### Section 14.6: Secrets Management in GitOps
**Problem**: Cannot commit secrets to Git.
**Solutions**:
**Recommended**: External Secrets Operator (ESO) for Azure Key Vault integration.
**Example ESO**:
#### Section 14.7: Monitoring & Alerting
**Flux Notifications**:
**Key Metrics to Monitor**:
- Flux reconciliation failures (Kustomization/HelmRelease errors)
- Image automation lag (time from image push to Git commit)
- Helm release drift (manual kubectl edits detected)
#### Section 14.8: GitOps Best Practices

### Article XIV-B — FinOps & Cost Management (LOW)

**FinOps** (Financial Operations) is a cultural practice that brings financial accountability to cloud spending through collaboration between Finance, Engineering, and Business teams.
#### Section 14B.1: FinOps Team Structure
**Roles & Responsibilities**:
| Role                  | Responsibility                                       | Stakeholder      |
| --------------------- | ---------------------------------------------------- | ---------------- |
| **FinOps Lead**       | Define cost policies, review budgets, cost reporting | Finance/IT       |
| **Engineering Teams** | Tag resources, optimize workloads, forecast capacity | DevOps/Eng       |
| **Product Owners**    | Prioritize cost vs features, approve spending        | Product/Business |
| **Executives**        | Set budget constraints, approve reservations         | C-Level          |
**Recommended Team Size**: 1 FinOps Lead per 20-50 engineers.
#### Section 14B.2: Cost Visibility & Tagging Strategy
**Mandatory Tags** (enforced via Azure Policy):
| Tag           | Purpose                        | Example           |
| ------------- | ------------------------------ | ----------------- |
| `Environment` | Separate dev/uat/prod costs    | `prod`            |
| `CostCenter`  | Chargeback to business unit    | `marketing`       |
| `Owner`       | Team responsible for resources | `platform-team`   |
| `Application` | Group resources by app         | `customer-portal` |
| `Project`     | Track project budgets          | `project-phoenix` |
**Azure Policy Tag Enforcement**:
#### Section 14B.3: Budgets & Alerts
**Budget Configuration**:
**Alert Thresholds** (Azure Cost Management):
| Threshold          | Action                     | Recipient                |
| ------------------ | -------------------------- | ------------------------ |
| **50% of budget**  | Email alert                | FinOps Lead + Team Lead  |
| **80% of budget**  | Email + Teams notification | Team + Product Owner     |
| **100% of budget** | Escalation                 | Executives + FinOps Lead |
**Example**:
#### Section 14B.4: Cost Optimization Opportunities
**Compute Optimization**:
**Storage Optimization**:
**Database Optimization**:
**Networking Optimization**:
#### Section 14B.5: Azure Advisor Cost Recommendations
**Azure Advisor** provides automated cost optimization recommendations:
- Idle VMs (low CPU/memory usage) → Resize or delete
- Unattached disks → Delete orphaned managed disks
- Reserved Instances recommendations → Save 30-70% on predictable workloads
- ExpressRoute circuits with low bandwidth usage → Downgrade SKU
**Implementation**:
#### Section 14B.6: FinOps Metrics & KPIs
**Track Monthly**:
| Metric                         | Formula                                           | Target                |
| ------------------------------ | ------------------------------------------------- | --------------------- |
| **Cost per Customer**          | Total Cost / # Active Customers                   | Decreasing trend      |
| **Cost per Transaction**       | Total Cost / # Transactions                       | < $0.10               |
| **Cloud Spend Growth Rate**    | (Current Month - Previous Month) / Previous Month | < Revenue Growth Rate |
| **Waste Percentage**           | (Idle Resources Cost) / Total Cost                | < 10%                 |
| **Reserved Instance Coverage** | Reserved Cost / Total Eligible Cost               | > 70% for prod        |
**Dashboard**: Use Azure Cost Management Power BI connector or Grafana.
#### Section 14B.7: Commitment-Based Discounts
**Azure Reservations**:
- **1-year term**: 20-40% discount
- **3-year term**: 40-72% discount
- **Applicable to**: VMs, SQL Database, Cosmos DB, App Service, Data Factory
**Purchasing Strategy**:
- Analyze last 6 months of usage (Azure Advisor recommendations)
- Purchase Reservations for **stable prod workloads** only (not dev/uat)
- Start with 1-year commitments, upgrade to 3-year after validating stability
**Example**:
#### Section 14B.8: Chargeback & Showback
**Showback** - Inform teams of their costs (no billing):
- Monthly reports per team/application/cost center
- Use Azure Cost Management workbooks
**Chargeback** - Bill teams for actual consumption:
- Requires Finance approval and internal billing system
- Use tags (CostCenter, Application) to allocate costs
- Export cost data to ERP/billing system via Azure Cost Management API
**Implementation**:
#### Section 14B.9: FinOps Automation
**Automated Actions**:
**Example Azure Function (Delete Orphaned Disks)**:

### Article XIV-C — SRE & Reliability Engineering (LOW)

**Site Reliability Engineering (SRE)** ensures systems are reliable, scalable, and maintainable through engineering practices: SLOs, error budgets, toil reduction, and incident management.
#### Section 14C.1: Service Level Objectives (SLOs)
**SLI → SLO → SLA Hierarchy**:
- **SLI** (Service Level Indicator) - Quantitative measure (e.g., request success rate, latency p95)
- **SLO** (Service Level Objective) - Internal target (e.g., 99.9% success rate)
- **SLA** (Service Level Agreement) - External commitment with penalties (e.g., 99.95% uptime)
**SLO Definition**:
| Service     | SLI                         | SLO Target | Measurement Window    |
| ----------- | --------------------------- | ---------- | --------------------- |
| API Gateway | Success rate (HTTP 2xx/3xx) | 99.9%      | 30-day rolling window |
| Web App     | Latency p95                 | < 500ms    | 30-day rolling window |
| Database    | Availability                | 99.95%     | 30-day rolling window |
**SLO Formula**:
#### Section 14C.2: Error Budgets
**Error Budget** - Allowable downtime/failures before SLO is violated.
**Calculation**:
**Policy** (when error budget exhausted):
**Monitoring Error Budgets**:
#### Section 14C.3: Toil Reduction
**Toil** - Manual, repetitive, automatable work that doesn't add long-term value.
**Examples of Toil**:
- Manually restarting crashed services
- Manual deployment steps (copy-paste commands)
- Ticket-driven provisioning (create VM, create database)
- Manual log analysis for known issues
**Toil Reduction Strategies**:
**Goal**: Limit toil to < 50% of engineer time (Google SRE guideline).
#### Section 14C.4: Incident Management
**Incident Severity Levels**:
| Severity             | Definition                           | Response Time     | Escalation                       |
| -------------------- | ------------------------------------ | ----------------- | -------------------------------- |
| **SEV-1 (Critical)** | Complete service outage, data loss   | < 15 minutes      | Immediate executive notification |
| **SEV-2 (High)**     | Degraded performance, partial outage | < 1 hour          | On-call engineer + manager       |
| **SEV-3 (Medium)**   | Minor impact, workaround available   | < 4 hours         | Standard on-call rotation        |
| **SEV-4 (Low)**      | No user impact, cosmetic issues      | Next business day | Backlog prioritization           |
**Incident Response Process**:
**On-Call Rotation**:
#### Section 14C.5: Postmortem Process
**Blameless Postmortem** - Focus on systems, not individuals.
**Template**:

### Article XIV-D — Disaster Recovery & Business Continuity (LOW)

**Disaster Recovery (DR)** ensures business operations continue after catastrophic failures (region outage, data center failure, ransomware).
#### Section 14D.1: Recovery Objectives
**Define DR Requirements**:
| Metric                                   | Definition                     | Typical Values                             | Approval       |
| ---------------------------------------- | ------------------------------ | ------------------------------------------ | -------------- |
| **RPO** (Recovery Point Objective)       | Max acceptable data loss       | 1 hour, 15 min, 0 (sync replication)       | Business Owner |
| **RTO** (Recovery Time Objective)        | Max acceptable downtime        | 4 hours, 1 hour, < 5 min                   | Business Owner |
| **RCO** (Recovery Consistency Objective) | Data consistency after restore | Eventually consistent, strongly consistent | Tech Lead      |
**Cost vs Tolerance**:
#### Section 14D.2: DR Strategies
##### Strategy 1: Backup & Restore (Lowest Cost)
- **RPO**: 1-24 hours
- **RTO**: 4-24 hours
- **Cost**: $
- **Implementation**: Automated backups to geo-redundant storage
- **Use case**: Non-critical applications, dev/uat environments
##### Strategy 2: Pilot Light (Warm Standby)
- **RPO**: 15 minutes - 1 hour
- **RTO**: 1-4 hours
- **Cost**: $$
- **Implementation**: Minimal DR site (database replicas, scaled-down compute), scale up on failover
- **Use case**: Business applications with moderate RTO requirements
##### Strategy 3: Warm Standby (Active-Passive)
- **RPO**: < 15 minutes
- **RTO**: < 1 hour
- **Cost**: $$$
- **Implementation**: Fully provisioned DR site (50-100% capacity), auto-failover configured
- **Use case**: High-availability applications, customer-facing services
##### Strategy 4: Active-Active (Multi-Region)
- **RPO**: 0 (continuous replication)
- **RTO**: < 5 minutes (automatic failover)
- **Cost**: $$$$
- **Implementation**: Traffic split across regions, data synced bi-directionally
- **Use case**: Mission-critical systems, SLA > 99.99%
#### Section 14D.3: Azure DR Capabilities by Service
| Service                | DR Capability                      | Configuration                                            |
| ---------------------- | ---------------------------------- | -------------------------------------------------------- |
| **Azure SQL Database** | Active geo-replication             | Secondary replica in paired region, auto-failover groups |
| **Azure Cosmos DB**    | Multi-region writes                | Enable multi-region replication, automatic failover      |
| **Azure Storage**      | GRS (Geo-Redundant Storage)        | Data replicated to paired region, 15-min RPO             |
| **Azure VM**           | Azure Site Recovery (ASR)          | Replicate VMs to secondary region, orchestrated failover |
| **AKS**                | Multi-cluster + Traffic Manager    | Deploy to 2+ regions, use Azure Front Door for routing   |
| **App Service**        | Traffic Manager + Deployment Slots | Primary + secondary region, DNS-based failover           |
#### Section 14D.4: Backup Strategy
**Backup Frequency**:
| Data Type                | Backup Frequency        | Retention              | Storage              |
| ------------------------ | ----------------------- | ---------------------- | -------------------- |
| **Databases**            | Hourly transaction logs | 35 days (prod)         | GRS (Azure Backup)   |
| **File Storage**         | Daily snapshots         | 30 days                | ZRS/GRS (Azure Blob) |
| **Infrastructure (IaC)** | On every commit         | Indefinite (Git)       | GitHub/Azure Repos   |
| **Secrets**              | Manual export quarterly | Offline secure storage | Key Vault + HSM      |
**Azure Backup Configuration**:
#### Section 14D.5: Failover Testing
**DR Drills** - Test failover procedures quarterly (SEV-1 systems) or annually (SEV-2/3).
**Test Plan**:
**Azure SQL Failover Test**:
#### Section 14D.6: Multi-Region Architecture
**Active-Active Pattern** (Azure Front Door + multiple AKS clusters):
**Failover Logic**:
- If primary region health < 50% → Route 100% traffic to secondary
- If primary region restored → Gradual traffic shift (20% → 50% → 80%)
#### Section 14D.7: Runbook for Disaster Recovery
**Runbook Template**:

### Article XVI — Security Policies (LOW)

#### Section 16.1: Network Security
| Component                | Configuration                     |
| ------------------------ | --------------------------------- |
| Virtual Network          |
| Private Endpoints        |
| Web Application Firewall |
#### Section 16.2: Data Protection
| Policy                | Value                                                 |
| --------------------- | ----------------------------------------------------- |
| Encryption at Rest    |
| Encryption in Transit | TLS 1.2+ (mandatory)                                  |
| PII Handling          |
#### Section 16.3: Compliance Requirements
| Standard | Required       |
| -------- | -------------- |
| GDPR     |
| HIPAA    |
| SOC 2    |
| PCI-DSS  |

### Article XIX — Governance (LOW)

- Governance: amendments via ADR; AI agents MUST comply with this constitution (see constitution.md).
