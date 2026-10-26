# Bolt Framework Agents Guide

> Central reference for Bolt Framework agents, their purpose, supported parameters, invocation examples, and expected outcomes.

Owner: `@ava-group-iberiademos/boltf-smes`. Review every 30 days and on affected workflow changes.
See [DevOps documentation governance](devops-governance.md) for review records and maintenance controls.
The agent inventory reflects definitions installed in the checkout, not the entire marketplace.
When no agents are installed, the manual sync generates a 0-agent index without AI and removes
stale agent entries and sections. Automated sync does not advance the owner review date.

This document is the long-form reference for the Bolt agent catalog. Each agent follows the same structure so users can quickly understand how to invoke it and what to expect.

## How to Read This Guide

- Bolt agents are primarily prompt-driven, not CLI-driven.
- When this guide says `parameter`, it refers to information you should include in the prompt.
- If you are unsure which agent to use, start with `@Bolt Framework`.
- Specialized agents handle the detailed work after the orchestrator identifies the right next step.

## Documentation Structure

Each agent section in this file follows this structure:

1. Purpose
2. When to use it
3. Prompt parameters
4. Built-in handoffs or dependencies
5. Typical usage
6. Example interaction
7. Expected outcomes

## Agent Index

Available agents: 0.

No agents are defined in this checkout.

| Agent | Summary |
| --- | --- |


---
</br>

# Bolt Framework - Agents Glossary

> Comprehensive glossary of abbreviations, acronyms, and technical terms used throughout the agents of Bolt Framework documentation.

---

## A

### AAA Pattern
**Arrange-Act-Assert** testing pattern where tests are structured in three sections: setup (Arrange), execution (Act), and verification (Assert).

### AC (Acceptance Criteria)
Specific conditions that must be met for a user story or feature to be considered complete and acceptable.

### ACL (Anti-Corruption Layer)
A design pattern that isolates a domain model from external systems or legacy code to prevent domain corruption.

### ADR (Architecture Decision Record)
A document that captures an important architectural decision along with its context, alternatives considered, and consequences. Bolt Framework uses MADR format.

### ASVS (Application Security Verification Standard)
OWASP standard providing a basis for testing web application technical security controls and requirements.

### API (Application Programming Interface)
A set of definitions and protocols for building and integrating application software.

### APM (Application Performance Monitoring)
The monitoring and management of performance and availability of software applications.

### AMQP (Advanced Message Queuing Protocol)
An open standard application layer protocol for message-oriented middleware.

### Azure Monitor
Microsoft's comprehensive monitoring service for collecting, analyzing, and acting on telemetry from cloud and on-premises environments.

---

## B

### BDD (Behavior-Driven Development)
A software development approach that extends TDD by writing test cases in natural language (Gherkin syntax) that non-programmers can read.

### Bicep
A domain-specific language (DSL) for deploying Azure resources declaratively using Infrastructure as Code.

### Blocking Finding
A critical issue (🔴) in code review or security analysis that must be fixed before code can be merged or deployed.

### Bolt
A micro-iteration in the Bolt Framework, typically lasting 2-3 days, representing a deliverable increment of work with mandatory quality gates.

### Bounded Context
A central pattern in Domain-Driven Design defining explicit boundaries within which a particular domain model applies.

### Brownfield
An existing system or codebase that requires modernization or integration, as opposed to greenfield (new development).

### BUG-NNN
Bolt Framework bug identifier format where NNN is a sequential number (e.g., BUG-001, BUG-042).

---

## C

### C4 Model
A hierarchical set of software architecture diagrams for context, containers, components, and code (C4).

### CDN (Content Delivery Network)
A geographically distributed network of servers that deliver web content to users based on their location.

### CI/CD (Continuous Integration/Continuous Deployment)
Practices that automate the integration of code changes and deployment to production environments.

### CORS (Cross-Origin Resource Sharing)
A security feature that allows or restricts web applications running at one origin to access resources from a different origin.

### CQRS (Command Query Responsibility Segregation)
An architectural pattern that separates read and write operations for a data store.

### CSP (Content Security Policy)
A security standard to prevent cross-site scripting (XSS), clickjacking, and other code injection attacks.

### CSRF (Cross-Site Request Forgery)
A type of attack that forces authenticated users to submit a request to a web application against their will.

### CVE (Common Vulnerabilities and Exposures)
A system providing publicly known information-security vulnerabilities and exposures.

### CVSS (Common Vulnerability Scoring System)
A framework for communicating the characteristics and severity of software vulnerabilities.

### CWE (Common Weakness Enumeration)
A community-developed list of software and hardware weakness types.

---

## D

### DAST (Dynamic Application Security Testing)
Security testing that analyzes running applications to find vulnerabilities that an attacker could exploit.

### DDD (Domain-Driven Design)
An approach to software development that focuses on modeling software to match a domain according to input from domain experts.

### DDL (Data Definition Language)
SQL commands used to define database schemas (CREATE, ALTER, DROP).

### DevEx (Developer Experience)
The overall experience developers have while using tools, frameworks, and processes.

### DTO (Data Transfer Object)
An object that carries data between processes to reduce the number of method calls.

---

## E

### E2E (End-to-End)
Testing methodology that validates the flow of an application from start to finish, simulating real user scenarios.

### EF Core (Entity Framework Core)
Microsoft's lightweight, extensible, open-source ORM (Object-Relational Mapper) for .NET.

### Epic
A large body of work that can be broken down into smaller stories, typically spanning multiple sprints.

---

## F

### FR (Functional Requirement)
A specification of behavior that a system must support, describing what the system should do.

### Fullstack
A development scenario that includes both backend (server-side) and frontend (client-side) components, plus infrastructure.

---

## G

### GDPR (General Data Protection Regulation)
EU regulation on data protection and privacy for individuals within the European Union and European Economic Area.

### Gherkin
A business-readable, domain-specific language for describing software behaviors without detailing implementation (Given/When/Then).

### GitHub Actions
CI/CD platform that allows automation of build, test, and deployment pipelines directly in GitHub.

### GitFlow
A branching model for Git that defines a strict branching model designed around project releases.

### Greenfield
A new software project that starts from scratch without constraints from prior work, as opposed to brownfield.

---

## H

### HIPAA (Health Insurance Portability and Accountability Act)
US legislation providing data privacy and security provisions for safeguarding medical information.

### HSTS (HTTP Strict Transport Security)
A web security policy mechanism to protect websites against man-in-the-middle attacks.

---

## I

### IaC (Infrastructure as Code)
Managing and provisioning infrastructure through machine-readable definition files rather than manual processes.

### Integration Test
Testing where individual units are combined and tested as a group to expose faults in their interaction.

### Invariant
A condition that can be relied upon to be true during execution of a program, often used in domain modeling.

---

## J

### Jira
An issue tracking and project management tool developed by Atlassian, commonly used for agile teams.

### JWT (JSON Web Token)
A compact, URL-safe means of representing claims to be transferred between two parties for authentication.

---

## K

### Kaizen
Japanese term meaning "continuous improvement," a philosophy that focuses on continually improving processes.

### KPI (Key Performance Indicator)
A measurable value that demonstrates how effectively a company is achieving key business objectives.

### KQL (Kusto Query Language)
A query language used to explore and analyze data in Azure services like Application Insights and Log Analytics.

### Kubernetes
An open-source container orchestration platform for automating deployment, scaling, and management of containerized applications.

---

## L

### Legacy Code
Existing code, often outdated or poorly documented, that requires maintenance or modernization.

### Linting
The process of running a program that analyzes code for potential errors, stylistic issues, and suspicious constructs.

---

## M

### MADR (Markdown Any Decision Records)
A lean template for documenting architectural decisions in a simple, structured format.

### MCP (Model Context Protocol)
A protocol for providing context and tools to AI models, enabling integration with external systems.

### Micro-iteration
See "Bolt" - a small, time-boxed development iteration in the Bolt Framework.

### Mutation Testing
A testing technique that involves modifying (mutating) a program's source code to check if tests can detect the changes.

### MVP (Minimum Viable Product)
A version of a product with just enough features to satisfy early customers and provide feedback.

---

## N

### NFR (Non-Functional Requirement)
A specification of criteria that judges the operation of a system, rather than specific behaviors (e.g., performance, security).

### NuGet
The package manager for .NET, allowing developers to share and consume useful code.

---

## O

### OBO (On-Behalf-Of)
OAuth 2.0 flow where a service calls another service on behalf of a user.

### OIDC (OpenID Connect)
An identity layer on top of OAuth 2.0 protocol for authentication.

### OKR (Objectives and Key Results)
A goal-setting framework used to define and track objectives and their outcomes.

### OKLCH
A modern color space (Oklch) providing perceptually uniform color representation for CSS.

### OpenAPI
A specification for building APIs that defines a standard, language-agnostic interface for RESTful APIs.

### ORM (Object-Relational Mapping)
A programming technique for converting data between incompatible type systems using object-oriented programming languages.

### OWASP (Open Web Application Security Project)
An online community producing freely-available articles, methodologies, documentation, tools, and technologies in web application security.

### OWASP Top 10
A standard awareness document representing a broad consensus about the most critical security risks to web applications.

---

## P

### P1, P2, P3 (Priority Levels)
- **P0/P1**: Critical/High priority - must be addressed immediately or within a sprint
- **P2**: Medium priority - should be addressed soon
- **P3**: Low priority - nice to have, can be deferred

### PagerDuty
An incident management platform for IT departments to receive and manage alerts.

### PCI-DSS (Payment Card Industry Data Security Standard)
A set of security standards designed to ensure companies that accept, process, store or transmit credit card information maintain a secure environment.

### Penpot
An open-source design and prototyping platform for design teams.

### PII (Personal Identifiable Information)
Any data that could potentially identify a specific individual.

### Playwright
A framework for web testing and automation, enabling cross-browser testing.

### Podman
An open-source container engine that's compatible with Docker but doesn't require a daemon.

### PostgreSQL
An open-source relational database management system emphasizing extensibility and SQL compliance.

### PR (Pull Request)
A method of submitting contributions to a project where changes are reviewed before being merged.

### Prometheus
An open-source monitoring and alerting toolkit designed for reliability and scalability.

---

## Q

### Quality Gate
A set of predefined criteria (e.g., code coverage, mutation score, linting) that code must pass before proceeding.

---

## R

### RCA (Root Cause Analysis)
A method of problem-solving used to identify the root causes of faults or problems.

### RC (Release Candidate)
A beta version with potential to be a final product, unless significant bugs emerge.

### RED-GREEN-REFACTOR
The TDD cycle: write a failing test (RED), make it pass (GREEN), then improve code quality (REFACTOR).

### Redis
An open-source, in-memory data structure store used as a database, cache, and message broker.

### Reqnroll
A .NET BDD framework (fork of SpecFlow) for writing executable specifications in Gherkin.

### REST (Representational State Transfer)
An architectural style for designing networked applications using stateless communication.

### RUM (Real User Monitoring)
A type of performance monitoring that captures and analyzes every transaction by actual users of a website or application.

---

## S

### SAST (Static Application Security Testing)
Security testing that analyzes source code to find security vulnerabilities without executing the program.

### SCA (Software Composition Analysis)
The process of identifying open-source and third-party components in use and their associated security vulnerabilities.

### SemVer (Semantic Versioning)
A versioning scheme using MAJOR.MINOR.PATCH format to communicate the nature of changes.

### SEV-1, SEV-2, SEV-3
Severity levels for incidents:
- **SEV-1**: Critical - complete outage or data loss
- **SEV-2**: High - major functionality impaired
- **SEV-3**: Medium - minor functionality affected

### SIEM (Security Information and Event Management)
A solution that provides real-time analysis of security alerts generated by applications and network hardware.

### SLA (Service Level Agreement)
A commitment between a service provider and client defining the level of service expected.

### SLI (Service Level Indicator)
A carefully defined quantitative measure of some aspect of the level of service provided.

### SLO (Service Level Objective)
A target value or range of values for a service level measured by an SLI.

### Smoke Test
A preliminary test to reveal simple failures severe enough to reject a prospective software release.

### SMTP (Simple Mail Transfer Protocol)
An internet standard for email transmission across Internet Protocol networks.

### SOC2 (Service Organization Control 2)
An auditing procedure ensuring service providers securely manage data to protect organizational interests and client privacy.

### SOLID Principles
Five design principles in object-oriented programming:
- **S**: Single Responsibility Principle
- **O**: Open/Closed Principle
- **L**: Liskov Substitution Principle
- **I**: Interface Segregation Principle
- **D**: Dependency Inversion Principle

### SQL (Structured Query Language)
A domain-specific language for managing and querying relational databases.

### SRE (Site Reliability Engineering)
A discipline that incorporates software engineering aspects to infrastructure and operations problems.

### SSE (Server-Sent Events)
A server push technology enabling a client to receive automatic updates from a server via HTTP connection.

### SSRF (Server-Side Request Forgery)
A security vulnerability that allows an attacker to force a server to make requests to unintended locations.

### SSL/TLS (Secure Sockets Layer / Transport Layer Security)
Cryptographic protocols providing secure communications over a computer network.

### Stryker
A mutation testing framework that validates the quality of test suites by introducing bugs.

---

## T

### Tailwind CSS
A utility-first CSS framework for rapidly building custom user interfaces.

### TDD (Test-Driven Development)
A software development approach where tests are written before the code that needs to be tested.

### Terraform
An open-source infrastructure as code software tool for building, changing, and versioning infrastructure safely and efficiently.

### TTL (Time To Live)
The amount of time or "hops" that a packet or data should exist before being discarded.

---

## U

### UAC (User Account Control)
A Windows security feature that helps prevent unauthorized changes to the operating system.

### Ubiquitous Language
In DDD, a common language shared by developers and domain experts to describe the domain model.

### UC (Use Case)
A written description of how users will perform tasks in a system, describing functional requirements.

### UI (User Interface)
The space where interactions between humans and machines occur.

### Unit Test
Software testing method where individual units of source code are tested in isolation.

### URI (Uniform Resource Identifier)
A string of characters that unambiguously identifies a particular resource.

### US (User Story)
A short, simple description of a feature from the perspective of the end user.

### UX (User Experience)
The overall experience of a person using a product, especially in terms of how easy or pleasing it is.

---

## V

### Value Object
In DDD, an immutable object that describes characteristics but has no conceptual identity.

### VNet (Virtual Network)
Azure's representation of a network in the cloud, providing isolation and segmentation.

### VO (Value Object)
See "Value Object" above.

### VPA (Vertical Pod Autoscaler)
Kubernetes feature that automatically adjusts CPU and memory requests/limits for containers.

---

## W

### WAF (Well-Architected Framework)
Microsoft's (or AWS's) set of guiding principles for building reliable, secure, efficient, and cost-effective systems.

### WCAG (Web Content Accessibility Guidelines)
Guidelines for making web content more accessible to people with disabilities.

### Wireframe
A visual guide representing the skeletal framework of a user interface.

---

## X

### XSS (Cross-Site Scripting)
A security vulnerability that allows attackers to inject client-side scripts into web pages viewed by other users.

---

## Y

### YAML (YAML Ain't Markup Language)
A human-readable data serialization language commonly used for configuration files.

---

## Z

### Zero Downtime Deployment
A deployment strategy where new versions are released without service interruption.

### ZRS (Zone-Redundant Storage)
Azure storage replication option that synchronously replicates data across three availability zones.

---

## Bolt Framework Specific Terms

### Agent
An AI-powered specialized workflow handler in the Bolt Framework (e.g., `@Bolt Plan`, `@Bolt Implement`).

### Article (Constitution)
A numbered section in the Bolt Framework constitution defining project rules and constraints.

### Bolt Branch
A Bolt branch following the pattern `bolt/[feature-slug]/bolt-[N]-[short-desc]` for micro-iterations.

### Constitution
The project DNA document defining tech stack, standards, constraints, and architectural decisions.

### Feature Branch
A git branch following the pattern `feature/[XXX-name]` containing all work for a specific feature.

### Quality Gate
Mandatory validation checkpoints in the Bolt Framework (lint, coverage ≥80%, mutation ≥70%).

### Scenario
The application type classification in Bolt Framework: backend-only, frontend-only, infra-only, backend+frontend, or fullstack.

### Skill
A reusable, specialized capability in the Bolt Framework stored in `.claude/skills/` or `.github/skills/`.

### Spec
Short for "specification" - a structured requirements document in `specs/[XXX-feature-name]/`.

### Task List
The breakdown of a feature into executable tasks, organized by Bolt iterations, stored in `planning/tasks.md`.

---

## Color and Design Terms

### OKLCH Color Space
A perceptually uniform color space (Lightness, Chroma, Hue) providing better color consistency than RGB/HSL.

### Design Token
A named entity storing visual design attributes (colors, spacing, typography) for consistent UI theming.

### Design System
A collection of reusable components, guided by clear standards, to maintain consistency across products.

---

## Testing Terminology

### @smoke Tag
A test annotation marking critical-path scenarios that should run on every build.

### Characterization Test
A test that captures the current behavior of legacy code to ensure modernization preserves functionality.

### Golden Master
A known-good output used as reference in characterization testing to verify behavioral equivalence.

### Parity Test
Testing that verifies new code produces identical results to legacy code for the same inputs.

### Test Pyramid
A testing strategy with 70% unit tests, 20% integration tests, and 10% E2E tests.

---
