# ADR-002: Govern DevOps Documentation as Reviewed Workflow Evidence

- Status: Proposed; maintainer approval required in the US-007 PR
- Date: 2026-10-16
- Owners: `@ava-group-iberiademos/boltf-smes`
- Review cadence: Every 90 days and on affected workflow changes; dates in the [document register](../devops-documents.json)
- Work item: US-007, Azure Boards AB#37993, Add Documentation Governance and Maintenance Controls
- Implementation: [PR #113](https://github.com/ava-group-iberiademos/bolt-framework/pull/113)
- Epic: Canonical tracker URL/ID not supplied; link it before declaring epic traceability complete

## Context

The delivery documentation epic established a [delivery flow](../delivery-flow.md),
[workflow catalog](../../.github/workflows/README.md), and
[release runbook](../release-operations-runbook.md). Workflow changes can leave these guides
stale, as demonstrated by the disabled agents-documentation schedule still described as active.
Article XI of the [constitution](../../.boltf/memory/constitution.md#article-xi-cicd-pipeline)
selects GitHub Actions and GitHub Flow but remains an unratified project template.

## Decision Proposed for Adoption

Keep YAML as the executable source of truth and prose as human-reviewed operator guidance.
Adopt the [governance policy](../devops-governance.md) and its machine-readable owner/review
register. Use the existing CODEOWNERS team as accountable owner until specialist teams exist.
Review operating documents every 30 days, governance/branch policy every 90 days, and all
affected documents on workflow changes.

Include the agents guide in the governed register with a 30-day owner review. Its catalog
represents agents installed in the checkout: absent or empty plugins produce a 0-agent index
and remove stale sections without AI. Keep the agent sync manual; provisioning marketplace
plugins is a separate prerequisite only when documenting that marketplace catalog.

Use deterministic YAML parsing, generated event/schedule inventory, and content fingerprints
to detect all workflow-file changes without an AI provider. Validate catalog membership in both
directions, PR checklist evidence, explicit no-update reasons, and review deadlines. Propose
generated changes through PRs rather than changing the default branch or auto-merging.
Keep narrative accuracy and approval independent from a successful inventory regeneration.
An inventory-only change requires an explicit no-update reason if catalog prose is unchanged.

Preserve these delivery epic distinctions: `main` is the only long-lived branch; `staging`
currently maps to canonical `uat`; no `pre` stage exists; CI/CD green does not prove all policy
gates passed; deployment/rollback placeholders are not real operations. Required merge checks,
code-owner approval, and production environment approval need verified GitHub settings.

## Alternatives Considered

- Manual-only review: cannot reliably detect missing/deleted workflows or overdue reviews.
- AI-only synchronization: adds provider/credential dependencies and can invent operator behavior.
- Automatic prose replacement or merge: obscures unresolved engineering gaps and owner accountability.
- Constitution amendment now: would imply ratification beyond US-007; this ADR records the proposal
  without changing the template's governance status.

## Consequences

Owners must maintain the register and review generated changes. New workflows require catalog
entries and detail sections before checks pass. Sync does not repair narrative guidance or reset
dates. Legitimate no-update reasons remain subject to independent review. Team existence and
repository protection settings cannot be proven from this checkout.

## Open Questions and Follow-Up

| Question                                                                                             | Accountable Owner                | Closure Evidence                                                                                                                 |
| ---------------------------------------------------------------------------------------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| What are the canonical epic and Azure Boards URLs and GitHub issue mapping for AB#37993?             | Documentation owner              | AB#37993 is confirmed and PR #113 is linked; canonical tracker URLs and any GitHub issue mapping remain pending                  |
| Who approves this ADR and ratifies Article XI?                                                       | Framework stewards               | Recorded decision/approval and, if needed, a separate constitution amendment                                                     |
| Which specialist teams replace the fallback owner?                                                   | Repository maintainers           | Valid teams, CODEOWNERS and document register updated together                                                                   |
| Are required checks and independent reviews enforced for `main` and feature targets?                 | Repository administrators        | Ruleset evidence naming `DevOps documentation governance` and code-owner review                                                  |
| Which identity may open sync PRs and trigger required checks?                                        | Repository administrators        | Approved Actions/App permissions and successful PR/check run links                                                               |
| When will real deployments, immutable promotion, scan gates, retention, and recovery be implemented? | Release/security/platform owners | Work items and validation evidence in the [GAP-008 register](../release-operations-runbook.md#gap-008-engineering-work-register) |

These questions remain open. US-007 supplies maintenance controls, not closure of the epic's
deployment/security gaps or proof that external settings are configured.
