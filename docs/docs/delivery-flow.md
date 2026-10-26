# Delivery Flow: Specification to Production

This guide documents the maintainer delivery flow and work traceability, based on the workflows in this repository. It distinguishes **policy**, **implemented automation**, and **deployment placeholders**. A successful workflow run is not proof of a production deployment.

Owner: `@ava-group-iberiademos/boltf-smes`. Review every 30 days and on affected workflow changes.
See [DevOps documentation governance](devops-governance.md) for review records and drift controls.

## Delivery Policy and Scope

The [constitution](../.boltf/memory/constitution.md) selects GitHub Actions (Article XI) and GitHub Flow: `main` is the only long-lived branch. Article XI now defines default validation thresholds and deployment-stage policy; repository-level rulesets and environment protections still require separate configuration and verification. The [branching strategy](../.boltf/docs/branching-strategy.md) governs branch naming and lifecycle.

The repository distributes a framework, not a configured production application. Its root package is private, has no application build/test scripts, and there is no root Dockerfile. Workflows therefore skip some application and publishing steps. Deployment, health checks, production approval steps, and rollback in the CD workflow are currently messages or commented examples, not executable deployment operations.

## Commit and Pull Request Standard

This section documents the repository's contributor policy and separates it from controls that require GitHub repository configuration. GitHub Flow and the branch lifecycle in the [branching strategy](../.boltf/docs/branching-strategy.md) are the selected repository policy. The [PR template](../.github/pull_request_template.md) includes the workflow documentation checklist; neither the template nor this guide substitutes for required GitHub rulesets or branch protection.

### Commit Messages

Use Conventional Commits with the GitHub issue ID as the scope. The issue ID must be the first and only scope value; do not replace it with a feature or component name.

```text
<type>(#<issue-id>): <imperative summary>
```

The supported types are:

| Type | Use |
| ---- | --- |
| `feat` | Add or change user-facing/framework capability |
| `fix` | Correct a defect |
| `docs` | Documentation-only change |
| `refactor` | Restructure without changing behavior |
| `test` | Add or change tests |
| `chore` | Maintenance work |

Examples:

```text
docs(#128): document commit and pull request policy
feat(#245): add scope-aware approval routing
fix(#318): preserve issue links in release notes
```

Keep the summary concise, imperative, lowercase after the colon, and without a final period. Add a body when context or implementation details help review. Put issue-closing keywords in a footer only when the change completes that issue; use `Part of #<id>` or `Refs #<id>` for work that does not complete it.

```text
fix(#318): preserve issue links in release notes

Keep the original issue reference when generating the release summary.

Closes #318
```

For work tracked outside GitHub in a consuming repository, use the canonical work-item identifier as the scope only when that repository's policy explicitly permits it and the tracker defines a stable identifier format; link the work item in the PR. This repository requires a GitHub issue-first scope, for example `docs(#128): ...`; external scopes such as `AB#37988` are not valid here unless maintainers update this policy. A trailing `(#128)` or a footer by itself does not replace that scope. If an ID is not yet known, the existing repository instruction permits a temporary feature-name scope, but warn the maintainer and link the work item in the PR once it is available.

### Pull Request Content

Use the same issue-first Conventional Commit shape for the PR title where the work has a GitHub issue, for example `docs(#128): document commit and pull request policy`. Every PR should:

- Target the branch required by the [branch lifecycle](../.boltf/docs/branching-strategy.md): Bolt branches target their parent feature; feature, bug-fix, hotfix, documentation, and contribution branches target `main`.
- Link the issue/work item and relevant specification, and state which user stories or acceptance criteria are covered. Use `Closes #<id>` only when the PR completes the linked issue; otherwise use a non-closing reference such as `Part of #<id>`.
- Summarize the reason for the change and the observable result. Call out breaking changes and migration needs.
- Include testing evidence: commands/checks run and their results. Identify skipped, unavailable, advisory, or not-applicable checks with a brief reason; do not describe skipped checks as passing.
- Describe operational and security risk, affected areas, deployment impact, and a rollback or recovery approach. For documentation-only work, state that no runtime deployment is involved and why rollback is not applicable.
- Update relevant documentation and changelog/release notes when the change affects documented behavior or belongs in a release. State when an update is not applicable.

Preserve the issue-first reference in the final squash commit message. Before merge, reviewers assess correctness, security, acceptance-criteria traceability, testing evidence, risk/rollback, and documentation impact. Confirm the required checks are complete and any warnings or skips have been assessed.

### Review and CODEOWNERS Governance

**Current checked-in governance:** Every branch is expected to use a PR and squash merge. The active [CODEOWNERS](../.github/CODEOWNERS) has a catch-all assignment to `@ava-group-iberiademos/boltf-smes`; its listed paths also assign that same team. This requests the configured code owners as reviewers, but does not by itself require their approval. The PR template includes an automated documentation-impact checklist. The repository's required approval count, required-check list, stale-review dismissal, and whether code-owner approval is mandatory are GitHub ruleset/branch-protection settings and cannot be confirmed from this checkout. Treat these as unverified until maintainers inspect the repository settings.

**Target governance:** Configure GitHub rulesets for protected targets to require the agreed independent approvals and checks, and to require code-owner review for owned paths. Define actual scope-owner teams and verify team membership before referencing them. The checked-in [`tobe_CODEOWNERS`](../.github/tobe_CODEOWNERS) is a proposal with `@your-org` placeholders, not active ownership; it sketches separate backend, frontend, platform, data, AI, and core owners. Once adopted, GitHub applies the last matching CODEOWNERS rule for a path, so keep specific scope rules after the catch-all. Require at least one approval from a matching owner for owned changes only after the corresponding ruleset is enabled.

**Exceptions:** If a matching owner is unavailable or a path has no valid owner, a maintainer should assign an independent subject-matter reviewer and record the reason in the PR. An emergency bypass or reduction of required approvals/checks is a target-governance exception, not an automatic CODEOWNERS behavior: an authorized maintainer must approve it, record the rationale and approver in the PR/work item, and preserve all feasible checks. The PR author cannot approve their own change. Do not represent an exception as a normal approval or as a control enforced by the workflow.

## End-to-End Flow and Traceability

1. **Specify and approve the work.** Capture the business goal, user stories, acceptance criteria, and requirements in `specs/XXX-feature-name/requirements/requirements.md`. The product owner or maintainer approves scope and acceptance criteria; the technical lead reviews the implementation plan before construction. See the [requirements template](../.boltf/docs/templates/requirements-template.md) and [agent workflow guide](AGENTS_GUIDE.md).
2. **Link epic, story, and task.** Track the feature/epic, its stories or Bolt iterations, and their tasks in the selected work tracker. In GitHub, use issues and sub-issues with parent-child links and explicit dependencies. Preserve the associated `issue: #<id>` in spec/planning metadata, with story and acceptance-criterion IDs in the task list. An epic/story/task is a planning level, not an additional Git branch requirement. Follow the [issue synchronization policy](../.github/copilot-instructions.md).
3. **Create branches.** After human confirmation of the feature branch name, create `feature/<feature-slug>` from `main`; implement iterations on `bolt/<feature-slug>/bolt-<N>-<short-desc>` and merge them into their parent feature branch. Do not introduce `develop`. Existing `feature/XXX-short-desc` names are migration exceptions, not the new naming convention.
4. **Commit with an issue reference.** Follow the [commit-message standard](#commit-messages), including the issue ID as the first and only scope, and preserve it in the final squash message. Include `Closes #<id>` only when the change completes that issue. Do not mark a partially delivered parent epic complete merely because one task is done.
5. **Open and review the pull request.** Follow the [PR content and review standard](#pull-request-content). Bolt PRs target the parent feature; feature PRs target `main`. Link the issue and spec, identify covered acceptance criteria, and include testing and deployment/rollback evidence. Review approval and required-check enforcement depend on GitHub repository settings; see [Review and CODEOWNERS Governance](#review-and-codeowners-governance).
6. **Run automated checks.** Pushes and PRs matching the trigger matrix below run CI, security, contracts, or infrastructure validation. Resolve blocking failures and review warnings/skips. Current CI does not automatically cover `bolt/**` pushes or PRs targeting `feature/**`; explicitly dispatch CI on the Bolt ref when validation is needed before its parent PR.
7. **Merge and select the deployment target.** A push to `main` triggers CI and CD independently. CD chooses `staging` (canonical `uat`) and invokes reusable CI unless tests are skipped. Human acceptance testing and promotion decisions must be recorded against the work item; there is no implemented automatic four-environment promotion chain.
8. **Create the release.** A maintainer chooses the version and approved commit, then pushes a `vMAJOR.MINOR.PATCH` tag or dispatches the release workflow with `version` and `release_type`. Tags should identify approved `main` commits, but tag ancestry is not validated by the workflow. Record release URL, tag, commit SHA, workflow run, artifact/image identity, and included issues. Release and production CD both react independently to version-tag pushes; neither waits for the other.
9. **Approve, verify, or roll back production.** Before a real production deployment, an authorized approver confirms the artifact, target, validation results, and rollback readiness. Verify health, smoke tests, and telemetry after deployment before declaring the work delivered. On failure, restore the previous known-good artifact and compatible configuration/data state, verify recovery, and link the incident and rollback evidence to the release and work item. The current workflow does not perform these operations.

The required evidence chain is: **spec and acceptance criterion -> epic/story/task issue -> branch and commits -> PR and checks -> deployed commit/artifact and environment -> release -> verification or rollback record**. Retain immutable SHAs/digests and workflow run URLs, not only mutable branch names or image tags. Workflows do not currently enforce issue IDs, sub-issue relationships, commit scopes, PR-to-spec links, or a release-to-spec manifest; maintainers review this evidence manually.

## Canonical Environments

Use canonical names in specs, configuration decisions, and delivery records. Preserve the exact GitHub environment names when selecting workflow inputs or configuring secrets and protections.

| Canonical name | Purpose and constitutional trigger                | Current workflow environment | Current behavior                                                                                                                      |
| -------------- | ------------------------------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `dev`          | Development; intended PR preview                  | `development`                | CD dispatch with `environment=development`; no PR-triggered CD exists.                                                                |
| `uat`          | User acceptance testing; intended merge to `main` | `staging`                    | CD on a `main` push, or dispatch with `environment=staging`. Here `staging` means `uat`, not `pre`.                                   |
| `pre`          | Pre-production; intended manual promotion         | None                         | No distinct job, environment, or dispatch choice implements `pre`. Do not alias it to `staging` without a policy and workflow change. |
| `prod`         | Production; intended manual approval              | `production`                 | CD on a version-tag push, or dispatch with `environment=production`; real approval requires external environment protections.         |

The additional environments `terraform-plan` in [infrastructure validation](../.github/workflows/infra-validation.yml) and `copilot` in [Copilot setup](../.github/workflows/copilot-setup-steps.yml) are execution contexts, not promotion stages. Referencing an environment in YAML does not establish required reviewers, allowed branches, secrets, or a deployed service. Confirm those settings in GitHub before using a production flow.

## Workflow Trigger Inventory

Branch filters on `pull_request` match the **target** branch. Where both branches and paths are specified, both must match. PR workflows without explicit activity types use the default opened, synchronize, and reopened activities. Scheduled runs use the default branch; all cron times below are UTC. A reusable workflow runs only when called. A dispatch runs against the selected ref, subject to job guards.

### CI, CD, Release, and Validation

| Workflow                                                               | Automatic conditions                                                                                           | Reusable or manual conditions                                                                          |
| ---------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| [CI](../.github/workflows/ci.yml)                                      | Push to `main`, `develop`, `feature/**`, or `release/**`; PR targeting `main` or `develop`. No path filter.    | `workflow_call` without declared inputs; dispatch without inputs.                                      |
| [CD](../.github/workflows/cd.yml)                                      | Push to `main` or tag matching `v*.*.*`.                                                                       | Dispatch: required `environment` choice `development/staging/production`; optional `skip_tests=false`. |
| [Release](../.github/workflows/release.yml)                            | Push of a tag matching `v*.*.*`.                                                                               | Dispatch: required `version` string and `release_type` choice `patch/minor/major/prerelease`.          |
| [Contract tests](../.github/workflows/contract-tests.yml)              | Push or PR on any branch when `contracts/**`, `src/**`, or `tests/**/*.feature` changes.                       | Dispatch without inputs.                                                                               |
| [Infrastructure validation](../.github/workflows/infra-validation.yml) | Push or PR on any branch when `infra/**`, `terraform/**`, `bicep/**`, `kubernetes/**`, or `helm/**` changes.   | Dispatch without inputs.                                                                               |
| [Security scan](../.github/workflows/security-scan.yml)                | Push or PR targeting `main` or `develop`; daily `0 3 * * *` (03:00).                                           | Dispatch without inputs.                                                                               |
| [Security analysis](../.github/workflows/security-analysis.yml)        | Push or PR targeting `main/master/develop`, ignoring `*.md`, `docs/**`, and `.github/copilot-instructions.md`. | Dispatch: `severity_threshold=medium`, `compliance_standard=owasp`, `run_full_scan=true`.              |

The `develop`, `master`, and `release/**` filters above are existing compatibility filters, not permission to change the selected GitHub Flow branch model. CI detects PR changes to selectively run contracts, integration tests, and framework smoke tests. Push, manual, and reusable CI execution follows its job guards, not that PR-only change filtering.

### Scheduled and Manual Maintenance

| Workflow                                                                    | Schedule                   | Manual condition and result                                                                                                                                                                                 |
| --------------------------------------------------------------------------- | -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Agents documentation sync](../.github/workflows/agents-doc-sync.yml)       | Disabled                   | Manual dispatch with `force_rebuild=false` scans checkout plugins. Missing or empty plugins generate a 0-agent index and remove stale sections without AI; marketplace documentation requires provisioning plugins first. A human reviews any generated PR. |
| [DevOps documentation governance](../.github/workflows/devops-doc-sync.yml) | Monday 08:40, `40 8 * * 1` | Every PR (including body edits) validates catalog, owner/cadence, and change evidence. Scheduled/manual runs propose generated inventory changes for review; they do not auto-merge or update review dates. |
| [Specification drift](../.github/workflows/spec-drift.yml)                  | Monday 08:00, `0 8 * * 1`  | Dispatch with `specs_path=specs/`, `src_path=src/`; produces a report issue and closes previous drift issues, not a delivery-blocking consistency gate.                                                     |
| [Framework update check](../.github/workflows/bolt-update-check.yml)        | Monday 08:23, `23 8 * * 1` | Dispatch with `force-check=false`; differing local/upstream versions can produce an update issue, not an automatic installation. Force permits another issue despite an existing one.                       |
| [Evolution check](../.github/workflows/evolution-check.yml)                 | Monday 09:00, `0 9 * * 1`  | Dispatch with `full_report=false`; reports dependency/quality/debt findings; issue step requires `full_report=true`.                                                                                        |
| [Bootstrap labels](../.github/workflows/bootstrap-labels.yml)               | None                       | Dispatch only, no inputs; creates/updates labels. Editing the label configuration does not trigger it.                                                                                                      |
| [Copilot setup steps](../.github/workflows/copilot-setup-steps.yml)         | None                       | Declared dispatch only, no inputs; checks out code and sets up Node 22. Not an application deployment.                                                                                                      |

### Issue Events and Reusable Access Workflows

These workflows handle framework access, not product deployment approvals. They are included to distinguish organizational approval automation from release gates.

| Workflow                                                               | Trigger and conditions                                                                                                                                       | Human or automated action                                                                                                             |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| [Access triage](../.github/workflows/issue-access-triage.yml)          | Issue opened or labeled; non-access opens notify SMEs, access opens call approval request, adding `approved-by-smes` to an access request calls group grant. | Routes issue events to reusable workflows with inherited secrets.                                                                     |
| [SME approval](../.github/workflows/sme-approve.yml)                   | New issue comment; requires access and pending labels plus a `/approve` or `/reject` prefix.                                                                 | Verifies commenter team membership before applying the human decision; nonmembers cannot approve.                                     |
| [SME approval request](../.github/workflows/sme-approval-request.yml)  | `workflow_call` only, required numeric `issue_number`; already-approved issues skip request actions.                                                         | Labels/comments/assigns the request; requires `ORG_TOKEN`.                                                                            |
| [Learning group grant](../.github/workflows/add-to-learning-group.yml) | `workflow_call` only, required numeric `issue_number`; invoked by approved access triage.                                                                    | Adds the parsed user to the organization team, comments and closes the issue; failure handler also closes the request as not planned. |

No workflow declares `workflow_run` or a release-event trigger. Scheduled/manual report jobs do not implicitly gate CI, CD, or release.

## Quality Gates and Blocking Policy

### Blocking Rule

For every applicable gate below, a failed, missing, cancelled, or inconclusive required check blocks merge, release, or promotion. A check may be marked not applicable only when its input is absent by design (for example, no container or IaC files); record the reason in the job summary or PR. A tool outage or skipped required test is not a pass: keep the change blocked and rerun, or follow the documented exception process. The [Article XI selections](../.boltf/memory/constitution.md#article-xi-cicd-pipeline) are policy defaults for projects with those assets; they do not assert that this framework repository has an application to build or deploy.

### Required Checks by Control Point

| Control point | Required policy checks | GitHub enforcement / current limitation |
| -------------- | ---------------------- | --------------------------------------- |
| Pull request into a feature branch or `main` | Build, lint/format, unit tests and coverage, applicable integration/architecture/mutation tests, security/dependency/secret scans, contract checks, IaC checks, and artifact checks. Checks not relevant to the changed project type must report not applicable with a reason. | Configure a branch ruleset requiring the stable aggregate required-check job and independent review. Current CI does not automatically cover PRs targeting `feature/**` or pushes to `bolt/**`; a green manual CI dispatch alone does not establish that all required policy checks passed. Update triggers and blocking aggregation to cover every applicable check. For manual validation evidence, run every applicable workflow on a ref resolving to the PR head SHA and inspect individual check reports against the thresholds below, including non-blocking failures and skipped checks; this evidence does not replace required ruleset enforcement. |
| Protected branches (`main`, and feature branches receiving Bolt PRs) | Every applicable PR check above must pass on the exact head SHA; require at least one approval and code-owner review, dismiss stale approvals, and prohibit force pushes/deletion for protected targets. | GitHub rulesets/branch protection are repository settings, not enforced by these files. Verify required-check identifiers and ruleset bypass actors in GitHub Settings. `CODEOWNERS` currently assigns all paths to `@ava-group-iberiademos/boltf-smes`; this requests ownership review only when the ruleset requires it. |
| Release | Validate that the release commit is an approved `main` commit with passing required checks; run applicable security, dependency, secret, contract, IaC, test, lint, build, and artifact gates; retain the immutable artifact digest and release metadata. | Release tags currently trigger release and CD independently; release does not depend on complete CI/security/IaC success or validate `main` ancestry. A release workflow gate and protected-tag/ruleset configuration are still required. |
| Deployment | Promote only the same verified artifact digest from the approved commit. Require the checks applicable to that artifact, environment-specific approval for production, post-deploy health/smoke verification, and a recorded recovery plan. Do not allow `skip_tests` to satisfy a required gate. | Configure environment protection and required reviewers for protected environments. Current CD accepts a test bypass and contains deployment/verification placeholders; it is not a real deployment gate. |

Rulesets should require a stable aggregate check that reports failure if a required applicable check fails or is skipped. Do not require a conditionally emitted check name as the only enforcement signal: GitHub can leave such checks pending or make their applicability ambiguous. Keep path-based detection inside the aggregate job, where it must distinguish a justified not-applicable result from an unavailable or silently skipped check. Require PRs for protected branch updates and restrict bypass to named maintainers. A tag ruleset can restrict who creates release tags, but release validation must still verify the tagged commit's checks because tag rulesets do not prove those checks passed.

### Gate Owners and Remediation

The contributor who introduced a failure owns the initial remediation. The accountable owner reviews findings, accepts a documented false positive, or assigns follow-up work. Until specialist CODEOWNERS are configured, the current repository fallback owner for each category is `@ava-group-iberiademos/boltf-smes`.

| Gate | Blocking threshold | Accountable owner | Remediation path |
| ---- | ------------------ | ----------------- | ---------------- |
| Security analysis | No unresolved Critical or High vulnerability findings. | Security owner; repository maintainer is current fallback. | Fix or upgrade the affected component, rerun the scan, and link the finding/report. High findings may use an approved, time-limited exception; Critical findings may not. |
| Dependencies | No unresolved Critical or High known vulnerabilities in shipped dependencies; lockfiles must be reproducible. | Dependency/security owner; repository maintainer is current fallback. | Upgrade, replace, or remove the dependency; rerun the audit. Record package, advisory, affected version, and fix in the PR/issue. |
| Secrets | No confirmed credential, private key, or token in source, history, logs, or artifacts. | Security owner; repository maintainer is current fallback. | Block immediately; revoke/rotate the secret, remove exposure, assess history and access, then rescan. A confirmed secret is never waived by `continue-on-error` or a policy exception. |
| Contracts | Contract/schema validation passes; breaking changes require an approved versioning and consumer-migration plan. | API/contract owner; repository maintainer is current fallback. | Correct schema/implementation drift or publish the approved breaking-change plan and compatibility evidence; rerun contract tests. |
| Infrastructure as code | Lint and validation/plan pass; no unresolved Critical/High policy findings; no PR apply. Cost is advisory unless an approved budget limit is configured. | Infrastructure owner; repository maintainer is current fallback. | Correct IaC or policy findings, inspect and attach the revised plan, then rerun validation. Never apply infrastructure changes from a PR gate. |
| Tests and coverage | All applicable tests pass; line coverage >= 80%, branch coverage >= 75%, mutation score >= 70% for application code. | Change author and test owner; repository maintainer is current fallback. | Add/fix tests or configure the missing test tooling, then rerun the required test commands. Missing mutation tooling is not a passing result. |
| Lint and build | Build succeeds with warnings treated as errors; lint/format reports zero errors and formatting check passes. | Change author and language/tooling owner; repository maintainer is current fallback. | Fix source/configuration or formatter output and rerun checks. |
| Artifact | Applicable build succeeds; artifact is attributable to the tested commit, scanned, and identified by immutable digest. | Release/artifact owner; repository maintainer is current fallback. | Rebuild from the approved SHA, resolve scan/provenance failures, and publish a new digest; do not promote a mutable tag as proof of identity. |

### `continue-on-error` and Exceptions

`continue-on-error` is allowed only for explicitly advisory reporting that cannot satisfy or mask a required gate. Examples include informational cost estimates when no budget is ratified, optional trend reports, or supplementary scanners whose blocking finding is independently enforced by another required check. The step/job summary must label the result advisory and expose any findings. It is prohibited for required build, lint, test, contract, secret, dependency/security threshold, IaC validation, and artifact-integrity checks. A required check that cannot execute must fail closed or remain blocked; it must not be converted to success by `continue-on-error`, `|| true`, or a skipped job.

An exception is limited to a non-critical gate with a concrete compensating control. It requires approval from both a repository maintainer/code owner and the accountable gate owner, neither of whom may be the PR author. Record the affected check and commit, reason, risk, compensating control, linked tracking issue, approvers, approval date, and expiry in the PR and issue. An exception expires after seven calendar days or at the next release, whichever comes first; rerun the check or obtain a newly reviewed exception. Exceptions cannot waive confirmed secrets, Critical vulnerabilities, required production environment approval, or an unapproved breaking contract change. Any emergency bypass must still preserve feasible checks and be recorded with the same audit details before the incident is closed.

### CI Evidence and Minimum Audit Trail

Retain CI logs and machine-readable test, security, contract, IaC, and artifact reports for at least 90 days. Retain release, deployment, approval, and exception records for at least one year, or longer when a legal, regulatory, or organizational retention rule applies. Do not place secrets or unredacted sensitive values in artifacts or PR comments. The PR/issue and release record must link the workflow run and capture:

- repository, workflow/run URL, event, source branch, commit SHA, and timestamp;
- required checks with pass/fail/not-applicable status, thresholds/results, and reason for every skip or exception;
- reviewer and code-owner approvals, plus any exception rationale, approvers, and expiry;
- release version, artifact name and immutable digest, target environment, and deployment approver;
- post-deployment health/smoke result, or rollback/incident reference and recovery verification.

These are minimum policy retention periods, not a statement of current configuration. The workflow inventory currently lists artifact retention as short as 5, 7, and 30 days, with no declared retention for some outputs. Update artifact `retention-days` and repository log-retention settings to meet this policy, then verify the effective limits in GitHub. The repository settings and external audit archives are not observable from this checkout.

## Human Approvals and Automated Gates

| Control point             | Human responsibility                                                                   | Implemented automation and limits                                                                                                                                                                                                                                                                        |
| ------------------------- | -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Spec and planning         | Approve scope, acceptance criteria, plan, and issue hierarchy.                         | Agent policies/templates guide this; workflows do not validate the hierarchy or approval record.                                                                                                                                                                                                         |
| Branch and PR             | Confirm feature branch name; review changes and issue/spec links; approve merge.       | CI executes on matching refs. Required reviews/checks must be configured in GitHub protections; YAML alone cannot prove enforcement.                                                                                                                                                                     |
| CI quality                | Resolve failures; explicitly assess warnings and skipped tests.                        | Available unit/build commands, script lint, Bats, Pester, framework smoke, and shared gates can fail. Missing tooling/scripts skip; coverage below 80% in CI warns rather than blocks. Mutation enforcement depends on configuration; the shared script default is 60%, not universal 70%.               |
| Security and contracts    | Triage findings before release.                                                        | Some secret scanners/validators fail, but many audits/scanners use `continue-on-error` or `\|\| true`. Cucumber/Pact test failures are masked; breaking-change checks include placeholders. Security analysis's final critical gate is hardcoded false; `run_full_scan` does not control its job guards. |
| Infrastructure            | Review plan, security/cost reports, and intended changes.                              | Type detection controls validators; plan is PR-only. Several scans/dry-runs are advisory. No infrastructure apply/deploy is implemented. The `terraform-plan` environment may have external protections.                                                                                                 |
| CD test bypass            | Authorize and record why `skip_tests=true` is acceptable.                              | Staging/production accept CI success or skip; development has no CI dependency. The staging/production guards do not explicitly require `build-image` success. This is not an all-checks-pass gate.                                                                                                      |
| Production promotion      | Approve target, artifact, readiness, and recovery plan.                                | `production` can use GitHub environment reviewers if configured externally. An echo saying approval was received is not approval enforcement.                                                                                                                                                            |
| Release and changelog     | Select version/commit, review assets and included work, and confirm merge governance.  | Release validates version syntax and available build/test scripts, but does not depend on full CI/security/infra or NPM publish success. Changelog PR automation attempts approval and auto-merge/direct-merge using a GitHub App token; it is not a guaranteed human sign-off.                          |
| Verification and rollback | Confirm real health/smoke/telemetry evidence; authorize recovery and incident closure. | CD verification/rollback steps are placeholders. Release rollback preparation prints commands; it does not restore a service.                                                                                                                                                                            |

See [test and CI documentation](../tests/README.md) and the [quality-gate implementation](../.boltf/scripts/bash/quality-gates.sh) for executable checks. CI's summary explicitly rejects build/unit failures, but other failed jobs can still fail the workflow. A green run with skipped or advisory checks must not be described as complete acceptance-criterion coverage.

## Release, Deployment, and Rollback Operations

Use the [operator runbook](release-operations-runbook.md) for repeatable release execution, publication checks, deployment prerequisites, rollback authority, communication, and audit records. Its [GAP-008 register](release-operations-runbook.md#gap-008-engineering-work-register) tracks open implementation work; documentation does not close those engineering gaps.

### Release Handoff

For the same version-tag push, CD builds a container when a Dockerfile exists and routes to production; release independently validates/builds, conditionally publishes GHCR/NPM artifacts, and creates a GitHub release. Both can write release metadata and images. There is no ordering or cross-workflow success dependency.

Dispatching release does not explicitly dispatch CD. Do not assume token-created tags, releases, or merges trigger another workflow: events generated by `GITHUB_TOKEN` generally do not start subsequent event-triggered runs. Record and verify the actual CD run separately.

NPM publication requires a non-private package, downloaded artifact, and `NPM_TOKEN`; the current root package cannot be published. Missing build assets can still result in a GitHub release without assets. A GitHub release is therefore a distribution record, not proof of production readiness or deployment.

### Selecting a Version and Environment

Version and environment are independent selections. `release_type` describes the semantic version change (`patch` for compatible fixes, `minor` for compatible features, `major` for breaking changes, or `prerelease` for a preliminary release); it does not select a deployment environment. For manual CD, `--ref` selects the source branch or tag and `environment` selects the target.

The following examples dispatch [CD](../.github/workflows/cd.yml) for the same existing tag, `v1.2.3`. Run only the command for the intended target, from the repository directory, using an authenticated GitHub CLI account authorized to run the workflow. The tag must exist remotely and contain the dispatch-enabled workflow; the workflow must also be available on the default branch.

Development (canonical `dev`):

```powershell
gh workflow run cd.yml --ref v1.2.3 -f environment=development -f skip_tests=false
```

User acceptance testing (canonical `uat`):

```powershell
gh workflow run cd.yml --ref v1.2.3 -f environment=staging -f skip_tests=false
```

Production (canonical `prod`, subject to configured environment approvals):

```powershell
gh workflow run cd.yml --ref v1.2.3 -f environment=production -f skip_tests=false
```

An explicit manual `environment` input takes precedence over the tag's automatic production routing. There is no `pre` choice. These commands dispatch the current placeholder deployment jobs; they do not deploy a real service. CD rebuilds from the selected source when a Dockerfile exists, so repeated runs do not guarantee promotion of the same immutable artifact.

**Warning:** Pushing a new tag matching `v*.*.*` already triggers the production CD path as well as release. Do not create or push a version tag expecting it to run only in UAT. Dispatching that existing tag to `staging` neither cancels nor gates the production run triggered by its push. Controlled artifact promotion (build once, select the same digest for each environment, approve production) requires a separate workflow change; it is not implemented by these examples.

### Deployment Readiness

Before claiming production delivery, maintainers must confirm real deployment implementation, environment protections, immutable artifact selection, secrets/authentication, health checks, and recovery procedures. The constitution has not selected a rollout strategy; CD's canary messages do not establish an implemented or ratified canary deployment.

Current registry actions use `GITHUB_TOKEN`; NPM uses `NPM_TOKEN`, and the changelog flow uses `RELEASE_BOT_APP_ID`/`RELEASE_BOT_APP_PRIVATE_KEY`. Terraform planning uses `ARM_CLIENT_SECRET` and related Azure variables, not federated authentication. Prefer federation for future Azure deployment wiring, but do not describe OIDC as already implemented.

### Rollback Procedure and Evidence

The current CD `rollback` job is dispatch-only with `failure()`, has no upstream `needs`, and references a prepare output it does not depend on. It is not a reliable automatic recovery mechanism. Do not rely on re-running CD or the release `rollback-prep` job to restore production.

Until a service-specific runbook and real deployment are configured, use the following as a **manual recovery checklist**, not commands known to work for this repository:

1. Stop promotion and record the failed run, environment, release/tag, commit, and incident. The release owner and operational approver decide rollback versus forward fix.
2. Select the previous verified artifact digest/version and its matching configuration. Check schema compatibility, migrations, backup availability, and whether restoring data requires separate authorization.
3. Execute the hosting-specific restore or traffic switch from the approved runbook. Never treat deleting a GitHub release or checking out an old commit as a runtime rollback.
4. Verify actual readiness/health endpoints, smoke tests, telemetry, and data integrity in the affected environment. Escalate if recovery fails.
5. Record the recovered artifact, approver, timestamps, commands/run URLs, and verification results. Link them to the incident, release, PR, and issues; mark the failed release appropriately and schedule corrective work.

## Workflow and Runbook References

All workflows are linked in the inventory above. The [release operations runbook](release-operations-runbook.md) covers the framework's current automation and consuming-service readiness requirements; it is not a populated service-specific production recovery procedure. Additional resources are templates and methodology references:

- [Deployment guide template](../.boltf/docs/templates/deployment-guide-template.md): environment setup, deployment, and rollback procedure structure.
- [Runbook template](../.boltf/docs/templates/runbook-template.md): operational procedures and recovery documentation.
- [Release notes template](../.boltf/docs/templates/release-notes-template.md): release and rollback communication.
- [Operations methodology](../plugins/bolt-core/skills/bolt-ops/SKILL.md): operational handoffs and incident response.
- [Script reference](../.boltf/scripts/README.md): operations and release helper usage. Helper existence does not mean CD invokes it.
- [Branching strategy](../.boltf/docs/branching-strategy.md): feature/Bolt PR targets, lifecycle, and merge rules.

There are no populated service runbooks under `docs/ops/runbooks/` in this checkout. The CD release-notes link to `docs/migration.md` also has no target here. A consuming application must supply its own approved deployment, verification, migration, and rollback runbooks before operational use.

## Acceptance-Criteria Coverage

| PBI acceptance criterion | Documentation location |
| ------------------------ | ---------------------- |
| Conventional Commit types/scopes, issue-first references, PR content, review and CODEOWNERS governance | Commit and Pull Request Standard; Commit Messages; Pull Request Content; Review and CODEOWNERS Governance |
| Spec, epic/story/task, branch, commit, PR, checks, environment, release, rollback | End-to-End Flow and Traceability; Release, Deployment, and Rollback Operations |
| Article XI stage selections and thresholds are completed | [Article XI](../.boltf/memory/constitution.md#article-xi-cicd-pipeline) |
| Required checks are mapped to PRs, protected branches, releases, and deployments/rulesets | Quality Gates and Blocking Policy; Required Checks by Control Point |
| `continue-on-error` boundaries and exception approvers are defined | Quality Gates and Blocking Policy; `continue-on-error` and Exceptions |
| Security, dependency, secret, contract, IaC, test, lint, and artifact gates have owners and remediation paths | Quality Gates and Blocking Policy; Gate Owners and Remediation |
| CI evidence retention and minimum audit trail are defined | Quality Gates and Blocking Policy; CI Evidence and Minimum Audit Trail |
| Human approval points and automated gates | Human Approvals and Automated Gates |
| Canonical environment names mapped to workflow names | Canonical Environments |
| CI, CD, release, scheduled, reusable, and manual trigger conditions | Workflow Trigger Inventory |
| Links to workflows and runbooks | Workflow Trigger Inventory; Workflow and Runbook References |

Update this guide whenever workflow triggers, guards, environment names, branch policy, or deployment/runbook implementation changes. Validate links and compare the inventory with every file in `.github/workflows/`; do not silently convert a placeholder into an operational claim.
