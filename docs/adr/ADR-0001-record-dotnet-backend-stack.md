# ADR-0001: Record the .NET Backend Stack Selection

## Status

Accepted (selected in the initialization wizard; project-specific rationale remains undocumented)

## Context

The greenfield initialization wizard selected the .NET 8 backend template for the full-stack
project. It did not record a project-specific comparison of backend frameworks or runtime needs.

## Decision

Use C# on .NET 8 (LTS) as the backend runtime, as recorded in `.boltf/scopes.yaml`.

This decision does not select an API style, architecture style, database, data-access technology,
identity provider, or authorization model. Those remain undecided.

## Rationale

The available evidence is the explicit wizard selection and the template lock to .NET 8. No further
business or technical rationale was captured, so this ADR records the outcome without claiming the
selection is superior to the alternatives.

## Alternatives Considered

The wizard also offered Go, Node.js/NestJS, Python/FastAPI, and a custom backend template. The lab
records .NET 8 as selected but does not record reasons for not selecting the alternatives.

## Consequences

- Backend implementation and tooling must target .NET 8 until this ADR is superseded.
- API style, persistence, authentication, and architecture decisions must be made separately.
- The project owner should add the requirements that motivated this selection if a comparative
  rationale is required.