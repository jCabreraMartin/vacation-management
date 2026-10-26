# ADR-0002: Record the Angular Frontend Selection

## Status

Accepted (selected in the initialization wizard; framework version remains unspecified)

## Context

The greenfield initialization wizard selected Angular for the frontend. It did not ask for or
record a major version, nor did it capture a project-specific comparison of frontend frameworks.

## Decision

Use Angular for the frontend. The framework version is not selected by the available lab evidence
and must be confirmed before scaffolding or dependency installation.

## Rationale

The wizard explicitly records Angular as the selected framework. No additional business or
technical rationale was captured, so this ADR records the outcome without inventing comparative
advantages.

## Alternatives Considered

The wizard offered React, Vue.js, and no or multiple frontend frameworks. The lab records Angular
as selected but does not record reasons for not selecting the alternatives.

## Consequences

- Frontend instructions and scaffolding should target Angular after its version is confirmed.
- The project owner should document the requirements that motivated Angular if a comparative
  rationale is required.