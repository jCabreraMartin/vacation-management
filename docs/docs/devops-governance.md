# DevOps Documentation Governance

This is the entry point for US-007 (Azure Boards AB#37993), **Add Documentation Governance and Maintenance Controls**.
The accountable documentation owner is `@ava-group-iberiademos/boltf-smes`. Review this policy
every 90 days and whenever workflows change. Ownership follows the active
[CODEOWNERS](../.github/CODEOWNERS), not the proposed scope-team placeholders.

## Governed Documents

The [machine-readable register](devops-documents.json) is the source of truth for owners,
review dates, and maximum review intervals. Every listed document also requires review when
a workflow change affects it. New DevOps operating or policy documents must be registered
in the same PR; reviewers confirm scope, since automation cannot classify arbitrary prose.

| Document                                                                   | Accountable Owner                   | Maximum Review Interval |
| -------------------------------------------------------------------------- | ----------------------------------- | ----------------------- |
| [Workflow catalog](../.github/workflows/README.md)                         | `@ava-group-iberiademos/boltf-smes` | 30 days                 |
| [Agents guide](AGENTS_GUIDE.md)                                            | `@ava-group-iberiademos/boltf-smes` | 30 days                 |
| [Delivery flow and gates](delivery-flow.md)                                | `@ava-group-iberiademos/boltf-smes` | 30 days                 |
| [Release, deployment, and rollback runbook](release-operations-runbook.md) | `@ava-group-iberiademos/boltf-smes` | 30 days                 |
| [Branching strategy](../.boltf/docs/branching-strategy.md)                 | `@ava-group-iberiademos/boltf-smes` | 90 days                 |
| This governance policy                                                     | `@ava-group-iberiademos/boltf-smes` | 90 days                 |

The initial register dates establish the US-007 baseline, subject to owner approval in its PR.
The agents guide follows the agent definitions available in the checkout, not the entire
marketplace. Its manual sync produces a 0-agent index when no plugins are installed and
removes stale agent entries and sections without AI. An automated guide update does not
replace owner review or advance its review date.
For subsequent reviews, the owner compares the document with workflow YAML and relevant
repository/environment settings, corrects discrepancies, and records findings and evidence
in the review PR before advancing `lastReviewed`. An automated sync never advances that date.
Ownership transfer requires the receiving owner's acknowledgement in the PR and a register
update. If an owner is unavailable, a maintainer assigns an independent reviewer and records
the temporary delegation; the author cannot approve their own review.

## Change Control

Every workflow-changing PR must complete the three DevOps checklist items in the
[PR template](../.github/pull_request_template.md). Check every added, renamed, and removed
workflow against the searchable catalog and detail sections, then review triggers, dispatch
and reusable inputs, permissions, secret/variable names, environments, outputs, artifacts,
failure/retry behavior, and deployment limitations. Never document secret values.

Run these commands from the repository root after installing dependencies with `npm install`:

```text
npm run docs:devops:sync
npm run docs:devops:test
npm run docs:devops:check
```

Commit the generated inventory together with relevant narrative updates. If no narrative
update is needed, record a specific explanation in the PR body, for example:

```text
DevOps-Docs-Not-Needed: Comment-only spelling correction; triggers, interfaces, and operator behavior are unchanged.
```

The reason must be at least 20 characters and is assessed by the reviewer, not semantically
approved by a script. It does not waive inventory synchronization, catalog completeness, or
review deadlines. Do not copy a placeholder reason. Documentation updates outside the catalog
still require either a narrative catalog update or this explicit catalog no-update explanation.
Regenerating only the inventory does not count as a narrative update.

## Automation and Recovery

[DevOps documentation governance](../.github/workflows/devops-doc-sync.yml) runs on every PR
to any target branch, including PR body edits, plus Mondays at 08:40 UTC and manual dispatch.
The stable `DevOps documentation governance` check validates YAML, the generated inventory,
one catalog entry and detail section per active `.yml`/`.yaml` workflow, document existence,
owners, review intervals/dates, and workflow-change PR evidence. Backups are excluded.

The generated inventory includes actual event names, cron schedules, and normalized-content
SHA-256 fingerprints. Any workflow content change is detected, including steps and permissions;
new and removed workflows are detected in both directions. Fingerprints are change detectors,
not semantic proof that narrative instructions are correct.

Scheduled/manual runs regenerate only the bounded inventory and propose a documentation PR
when it differs. They never rewrite operator prose, update review dates, or auto-merge. Missing
or stale narrative entries and expired reviews still fail validation and require owner action.
If an existing sync PR is open, the run fails with its URL instead of creating duplicates;
update or close that PR before retrying. If PR creation is blocked, the run fails visibly;
inspect its pushed branch, open the PR manually, and correct repository token permissions.

Default sync authentication uses `GITHUB_TOKEN`. The repository must allow Actions to create
PRs. If policy requires another identity, configure `DEVOPS_DOC_SYNC_TOKEN` with repository
contents/PR write access. Never expose the token. A `GITHUB_TOKEN`-created PR may not trigger
other workflows automatically; use an approved GitHub App token or a human-authored PR/update
and verify that required checks actually ran on the final SHA. There is no AI dependency.

Maintainers must configure rulesets to require `DevOps documentation governance` on protected
targets and require independent code-owner review. YAML alone cannot enforce merge protection.
Inspect each weekly run; the owner resolves drift/overdue reviews in a PR before the next merge.
Run logs and PR links are the audit trail; no new artifact retention policy is introduced.

## Decisions and Open Questions

[ADR-002](adr/ADR-002-devops-documentation-governance.md) records the delivery epic's known
policy choices, rejected alternatives, and unresolved enforcement, deployment, retention, and
ownership questions. Its status is proposed pending maintainer approval; this work does not
ratify the template constitution or claim to resolve the runbook's engineering gaps.

The PBI is US-007, Azure Boards AB#37993, implemented in [PR #113](https://github.com/ava-group-iberiademos/bolt-framework/pull/113).
The canonical epic and Azure Boards URLs remain pending; no GitHub issue ID is inferred from
the story number or external work-item ID.
