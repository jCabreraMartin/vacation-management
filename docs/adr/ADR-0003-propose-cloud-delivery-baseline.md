# ADR-0003: Propose the Cloud Delivery Baseline

## Status

Proposed; resolve the branch and development-deployment trigger conflict before implementation.

## Context

The initialization wizard selected GitHub Actions, Terraform, Podman for local container
development, OpenTelemetry to Azure, rolling deployments, GitHub Flow, and the application and
infrastructure pipeline stages. It also selected a dev deployment on commits to `develop`, UAT on
PR merge, and production with manual approval.

## Decision

Record GitHub Actions, Terraform, Podman local development, OpenTelemetry to Azure, rolling
deployments, and GitHub Flow as the selected baseline. Keep dev deployment behavior proposed until
the conflict between commits to `develop` and GitHub Flow's `feature/*` to `main` model is resolved.

The wizard selected 80% unit-test coverage and a 60% mutation score. It also selected VNet, Private
Endpoints, WAF, Azure-managed encryption keys, PII encryption, GDPR, and HIPAA. These selections do
not establish that the compliance requirements apply or that the controls are implemented.

## Rationale

The wizard selections are the only recorded evidence. It did not capture project-specific
comparisons, cloud constraints, compliance applicability, or why these options were preferred.
This ADR therefore records the selections and outstanding questions rather than asserting a
technical justification.

## Alternatives Considered

The wizard offered alternative pipeline providers, IaC tools, observability approaches, deployment
strategies, and branch models. The lab records the selected options but not the reasons for rejecting
the alternatives.

## Consequences

- The listed tooling and pipeline stages can guide planning, but implementation must wait on the
  dev trigger and branch-model resolution.
- The project owner must confirm whether GDPR and HIPAA apply and define the required control
  evidence before claiming compliance.
- Infrastructure and security policy selections are requirements, not proof of deployed controls.