# GitHub Actions Operator Guide

This is the operator index for the active GitHub Actions workflows in this directory. It is based on the workflow YAML, not on repository-level settings that are not visible here. Secret values are never documented.

For release execution, publication evidence, deployment approvals, and incident recovery, use the [Release, Deployment, and Rollback Runbook](../../docs/release-operations-runbook.md). Its GAP-008 register tracks the open CD placeholders and required scan-gate engineering work.

## Scope and Maintenance

The catalog covers every active `*.yml` and `*.yaml` workflow listed below. Backup files such as `*.yml.bkp` and Markdown files in this directory are not runnable workflows and are excluded.

Review this catalog every 30 days and on every workflow change. See
[DevOps documentation governance](../../docs/devops-governance.md) for owners, review records,
PR evidence, sync recovery, and [ADR-002](../../docs/adr/ADR-002-devops-documentation-governance.md).
The generated inventory detects content drift; the searchable catalog and details remain owner-reviewed.

## Generated Workflow Inventory

Run `npm run docs:devops:sync` after changing YAML; never hand-edit this block.

<!-- BEGIN GENERATED WORKFLOW INVENTORY -->

| Workflow | Events and Schedule | SHA-256 |
| --- | --- | --- |
| [add-to-learning-group.yml](add-to-learning-group.yml) | `workflow_call` | d8a268c378e5b1695beb8fd1cdf9d41eccdbf9ab41661f66d97f5fd571ea5046 |
| [agents-doc-sync.yml](agents-doc-sync.yml) | `workflow_dispatch` | 7f757797144fff983caef75e46807715e99c5f287c6e65c36a989f22a6190f84 |
| [bolt-update-check.yml](bolt-update-check.yml) | `schedule, workflow_dispatch (23 8 * * 1 UTC)` | 9c9752e9b62f089eb78cb6f058409d0096f56821a8271131b1b74433770346e6 |
| [bootstrap-labels.yml](bootstrap-labels.yml) | `workflow_dispatch` | 91cf556b20788eab1a5dc099fc138b481e7027f11b3ffe020333c580822eeae4 |
| [cd.yml](cd.yml) | `push, workflow_dispatch` | ef9c029818e137bed022a08aa9cf32cd848210c9958849f13291c5782d1bbd6e |
| [ci.yml](ci.yml) | `pull_request, push, workflow_call, workflow_dispatch` | d2699b74ae296b631ab5cd6d95a11477f30f077c4c6c2649c9ece76e2f008bbe |
| [contract-tests.yml](contract-tests.yml) | `pull_request, push, workflow_dispatch` | def0194226a08c053cc9b52f90d7340f12734209ddee6a047607489e76bcb3a5 |
| [copilot-setup-steps.yml](copilot-setup-steps.yml) | `workflow_dispatch` | 19cd3c712e5da4113e984c95667ec0672943de0202be6689baa0a19202ada7ee |
| [devops-doc-sync.yml](devops-doc-sync.yml) | `pull_request, schedule, workflow_dispatch (40 8 * * 1 UTC)` | 63dc20c30191cda5a0b317c5de0b42edf5c34679722cc4c0f08a3899db3959d0 |
| [evolution-check.yml](evolution-check.yml) | `schedule, workflow_dispatch (0 9 * * 1 UTC)` | 8cfa3c736e9bcfeaf4b5fc91f0b9dd4993fafbbf1013da457504bcf51b5c2d72 |
| [github-issues-to-azure-boards.yml](github-issues-to-azure-boards.yml) | `schedule, workflow_dispatch (0 6 * * * UTC)` | cde3c9c68845eb2500067968bea8916bf19837a22be7b182ed64b14dacd186db |
| [infra-validation.yml](infra-validation.yml) | `pull_request, push, workflow_dispatch` | 2f35a0626a77ba643ba5562cb42de3c7c5f4ca2adff56c04a1bc42bcb012da10 |
| [issue-access-triage.yml](issue-access-triage.yml) | `issues` | 6368a3d3e678c27e1a43bc45354e77c087405a5e0257b75f1daee1ed6dc398dd |
| [release.yml](release.yml) | `push, workflow_dispatch` | 930dce708988e3c7e7abecd54ae4a89c2aba7934d3ac3b967512e1847a2b2674 |
| [security-analysis.yml](security-analysis.yml) | `pull_request, push, workflow_dispatch` | c1cb1c0b0071fbb33bd40f82c3c998ada47db76a065b152e9750a706003d06e3 |
| [security-scan.yml](security-scan.yml) | `pull_request, push, schedule, workflow_dispatch (0 3 * * * UTC)` | 2819c642c41a6022b8eff0d8cc4dd2ee2c5f94378aca0586ab935b2a751067bb |
| [sme-approval-request.yml](sme-approval-request.yml) | `workflow_call` | b710380f769402a126a7482d3f64f90bcf95aee5bcd803c3c3b39d77a3d837f2 |
| [sme-approve.yml](sme-approve.yml) | `issue_comment` | 5f05e77cf01161e4ab91a3a0a7785ce481c51e808e904906db2e8031f92aa366 |
| [spec-drift.yml](spec-drift.yml) | `schedule, workflow_dispatch (0 8 * * 1 UTC)` | c4fd24defa4e885f33607d3afce92f846fecb1e615c0b5ef5c9a1f73038de64b |

<!-- END GENERATED WORKFLOW INVENTORY -->

Every workflow is owned for review by `@ava-group-iberiademos/boltf-smes`, as defined by [CODEOWNERS](../CODEOWNERS). The CODEOWNERS rule requests review; branch protection and required-review enforcement depend on repository settings. Update the relevant entry whenever its workflow YAML, called interface, trigger, permissions, environment, secret/variable dependency, artifact, or behavior changes. Review the entry as part of every workflow change.

`GITHUB_TOKEN` refers to GitHub's run-scoped token, not a repository secret to create. `permissions: not declared` means effective token access depends on repository/organization Actions settings and any calling workflow. Confirm those settings before diagnosing authorization failures. Listed secrets and variables are names only; verify existence and scope in **Settings → Secrets and variables → Actions** without copying values into this guide.

## Searchable Catalog

| Workflow                                                                 | Purpose                                                                                                                |
| ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| [`agents-doc-sync.yml`](#agents-doc-syncyml)                             | Detect drift between installed plugin agents and `docs/AGENTS_GUIDE.md`; open a review PR.                             |
| [`add-to-learning-group.yml`](#add-to-learning-groupyml)                 | Reusable workflow that grants approved learning-team access.                                                           |
| [`bootstrap-labels.yml`](#bootstrap-labelsyml)                           | Create or synchronize repository labels.                                                                               |
| [`bolt-update-check.yml`](#bolt-update-checkyml)                         | Check for a newer upstream Bolt Framework release and open an issue.                                                   |
| [`cd.yml`](#cdyml)                                                       | Deployment pipeline scaffold; deployment steps are placeholders.                                                       |
| [`ci.yml`](#ciyml)                                                       | Reusable and event-driven validation pipeline.                                                                         |
| [`contract-tests.yml`](#contract-testsyml)                               | Validate API/BDD contracts; several checks are optional or placeholders.                                               |
| [`copilot-setup-steps.yml`](#copilot-setup-stepsyml)                     | Minimal manually dispatched Copilot Cloud Agent setup.                                                                 |
| [`devops-doc-sync.yml`](#devops-doc-syncyml)                             | Validate documentation ownership, review deadlines, catalog completeness, and PR evidence; propose inventory sync PRs. |
| [`evolution-check.yml`](#evolution-checkyml)                             | Weekly dependency, quality, and technical-debt report.                                                                 |
| [`github-issues-to-azure-boards.yml`](#github-issues-to-azure-boardsyml) | Daily migration of GitHub issues to Azure DevOps Boards; labels and closes the source issue.                           |
| [`infra-validation.yml`](#infra-validationyml)                           | Validate detected infrastructure-as-code files.                                                                        |
| [`issue-access-triage.yml`](#issue-access-triageyml)                     | Route issue triage and access requests to reusable workflows.                                                          |
| [`release.yml`](#releaseyml)                                             | Build and publish a release, packages, and changelog update.                                                           |
| [`security-analysis.yml`](#security-analysisyml)                         | Stack-detected security analysis with reports and artifacts.                                                           |
| [`security-scan.yml`](#security-scanyml)                                 | Scheduled and change-triggered SAST, dependency, secret, IaC, and API scans.                                           |
| [`sme-approval-request.yml`](#sme-approval-requestyml)                   | Reusable workflow that requests SME approval for access issues.                                                        |
| [`sme-approve.yml`](#sme-approveyml)                                     | Process SME `/approve` and `/reject` issue comments.                                                                   |
| [`spec-drift.yml`](#spec-driftyml)                                       | Compare specifications with source and file a weekly drift issue.                                                      |

## Workflow Details

### `agents-doc-sync.yml`

- **Purpose and trigger:** Scans agent definitions in `plugins/*/agents/*.agent.md`; plugins without an `agents` directory are skipped. Manual dispatch only; the schedule remains disabled. If `plugins` is absent or contains no agents, generates an index with 0 agents and removes stale catalog entries and sections without loading the documentation agent or calling AI. Otherwise, updates `docs/AGENTS_GUIDE.md` when drift is found or a rebuild is forced. Opens a PR only if the guide actually changes. To document the marketplace catalog instead of the checkout inventory, provision authenticated plugins first.
- **Dispatch inputs:** `force_rebuild` (boolean, default `false`).
- **Permissions and configuration:** Workflow permissions: `contents: write`, `pull-requests: write`, `issues: write`. Optional variables: `AI_ENDPOINT`, `AI_MODEL` (defaults to GitHub Models and `gpt-4o`). Secrets: `AI_API_KEY` is required for non-GitHub-Models endpoints; `AGENTS_DOC_SYNC_TOKEN` is optional when `GITHUB_TOKEN` cannot create PRs. No environment is declared.
- **Outputs and artifacts:** Writes a run summary; pushes an `docs/agents-sync-*` branch and opens a PR when `docs/AGENTS_GUIDE.md` changes. No artifact upload.
- **Failure, retry, and rerun:** Missing AI credentials for a non-GitHub endpoint or blocked PR creation fails the run. If the branch push succeeds but PR creation fails, use the manual PR URL in the summary. A rerun can create another timestamped branch/PR; inspect existing runs and branches first.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update this entry when agent inventory rules, AI provider configuration, permissions, PR automation, or disabled/manual trigger changes.

### `devops-doc-sync.yml`

- **Purpose and trigger:** Every PR to any branch, including body edits, validates DevOps documentation governance. Monday 08:40 UTC and manual runs also propose generated inventory changes against the default branch.
- **Dispatch inputs:** None.
- **Permissions and configuration:** Default `contents: read`; trusted scheduled/manual sync job has `contents: write` and `pull-requests: write`. Optional `DEVOPS_DOC_SYNC_TOKEN` for approved PR automation; otherwise `GITHUB_TOKEN`. PRs never receive the sync write token. No environment or AI dependency. Node.js 22 and the root npm dependencies are required.
- **Outputs and artifacts:** Stable `DevOps documentation governance` check and logs; generated inventory PR on a `docs/devops-sync-*` branch when needed. No artifact upload or automatic merge.
- **Failure, retry, and rerun:** Invalid YAML, generated drift, missing/stale catalog membership, missing ownership, overdue reviews, or missing PR checklist/update/reason fail validation. Sync only rewrites the generated inventory; owners repair prose and review dates. An open sync PR blocks duplicate proposals. Permission failures fail with recovery guidance; a pushed branch can be used to open a manual PR. `GITHUB_TOKEN`-created PRs may need a human update or approved App token to trigger checks. See the governance policy before rerunning.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; review every 30 days and on changes to document scope, cadence, inventory generation, checklist enforcement, permissions, or sync PR behavior.

### `add-to-learning-group.yml`

- **Purpose and trigger:** Reusable `workflow_call` only. Reads the approved access issue, adds its GitHub username to the `boltf-learning` organization team, labels the issue `access-granted`, and closes it.
- **Dispatch inputs:** None. Caller input: required numeric `issue_number`.
- **Permissions and configuration:** Job permission: `issues: write`. Requires inherited secret `ORG_TOKEN` with organization team-membership administration capability (`admin:org`). No environment is declared.
- **Outputs and artifacts:** No declared workflow outputs or artifacts. Side effects are team membership, issue comment, label, and closure.
- **Failure, retry, and rerun:** Missing username or non-200/201 membership response fails the job. A failure handler comments and closes the issue as `not planned`, so an operator may need to reopen it after fixing the cause. Verify membership before rerunning; the API operation may be repeated.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when the caller, input, team slug, issue lifecycle, token scope, or grant/failure behavior changes.

### `bootstrap-labels.yml`

- **Purpose and trigger:** Manually creates or updates the repository's configured labels after repository setup or label changes.
- **Dispatch inputs:** None.
- **Permissions and configuration:** Bootstrap job permission: `issues: write`; uses `GITHUB_TOKEN`. No environment or repository secret is declared.
- **Outputs and artifacts:** No artifacts. Creates or edits ten labels: `access-request`, `approved-by-smes`, `pending-approval`, `access-granted`, `needs-triage`, `bug`, `enhancement`, `spec-drift`, `technical-debt`, and `migrated-to-azure-boards`.
- **Failure, retry, and rerun:** Upsert behavior makes reruns safe for the listed labels; each failed `gh` operation fails the step. Check run logs and rerun after correcting repository permission or API errors.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when labels, colors/descriptions, permissions, or setup procedure changes.

### `bolt-update-check.yml`

- **Purpose and trigger:** Compares `.boltf/bolt-manifest.yaml` with the latest upstream release every Monday at 08:23 UTC; can also be run manually.
- **Dispatch inputs:** `force-check` (boolean, default `false`); bypasses the existing-open-issue guard.
- **Permissions and configuration:** Workflow permissions: `issues: write`, `contents: read`; uses `GITHUB_TOKEN` to read the upstream release and create an issue. No environment or custom secret is declared.
- **Outputs and artifacts:** Creates a labeled issue containing the upstream release notes and update instructions when a newer version is found and no matching issue exists. No artifacts.
- **Failure, retry, and rerun:** If the upstream release lookup fails or returns no release, the workflow exits successfully without an issue. Normal reruns avoid an existing open issue; `force-check: true` can create duplicate issues, so use only after checking the issue tracker.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when the upstream repository, version comparison, issue labels/body, token permissions, or schedule changes.

### `cd.yml`

- **Purpose and trigger:** Runs on pushes to `main`, version tags `v*.*.*`, or manual dispatch. Resolves an environment, calls reusable CI unless skipped, conditionally builds/pushes a container image, and selects an environment deployment job.
- **Dispatch inputs:** `environment` (required choice: `development`, `staging`, `production`); `skip_tests` (boolean, default `false`).
- **Permissions and configuration:** `build-image` job: `contents: read`, `packages: write`; uses `GITHUB_TOKEN` for GHCR. Environments: `development`, `staging`, and `production`. No deployment credentials are configured in YAML.
- **Outputs and artifacts:** `prepare` outputs `version`, `environment`, `image_tag`; `build-image` outputs image, digest, and Dockerfile presence. Pushes an image only when a root `Dockerfile` exists. Writes deployment summaries; release tags conditionally create a GitHub Release.
- **Failure, retry, and rerun:** **Not production-capable as currently written.** Deployment, health checks, canary promotion, rollback, incident creation, and notifications are `echo` statements or comments/placeholders; environment URLs are examples. `skip_tests: true` skips CI, and staging/production explicitly allow CI to be skipped. Do not treat a green run as a deployed or verified release. A rerun repeats the selected side-effecting path; first inspect image/tag/release state.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when triggers, environment choices, CI call/skip conditions, image publication, deployment commands, health checks, rollback, or release behavior changes. A production-readiness claim requires replacing and validating the deployment placeholders first.

### `ci.yml`

- **Purpose and trigger:** Reusable `workflow_call`, manual dispatch, pushes to `main`, `develop`, `feature/**`, or `release/**`, and PRs targeting `main` or `develop`. Classifies changes and runs lint/format/type checks, security scans, unit/contract/integration tests, build, policy checks, script lint/tests, smoke tests, and a summary.
- **Dispatch inputs:** None. `workflow_call` has no declared inputs or secrets; `cd.yml` calls it with `secrets: inherit`.
- **Permissions and configuration:** No workflow-level permissions. The `security-scan` job declares `contents: read`, `security-events: write`; the script lint/test/smoke jobs declare `contents: read`. The caller/repository token policy must permit requested access. Uses Node.js 20 and Python 3.11. Integration tests use ephemeral Postgres/Redis services. No repository secrets are directly referenced.
- **Outputs and artifacts:** `detect-changes` outputs contract/integration/framework change flags. Uploads `contract-test-results`, `build-output` (7-day retention), `quality-gates-results` (30-day retention when reports exist), and `pester-results`; Codecov upload is conditional and non-blocking. Adds a job summary.
- **Failure, retry, and rerun:** CI failures are summarized by `ci-summary`; optional commands use `--if-present`, unit tests/build can be skipped when package scripts are missing, and coverage below 80% emits a warning rather than failing. npm audit and Trivy are `continue-on-error`; CodeQL skips when no eligible JS/TS source or CodeQL is unavailable. PR contract/integration/framework checks are change-gated. Reruns are generally safe; inspect skipped checks and warnings rather than treating them as passed validations.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when trigger filters, reusable interface, change classification, test commands, quality thresholds, permission needs, skip logic, or artifact names/retention change.

### `contract-tests.yml`

- **Purpose and trigger:** Runs on pushes and PRs that touch `contracts/**`, `src/**`, or `tests/**/*.feature`; also manual dispatch. Validates OpenAPI/AsyncAPI/GraphQL files when present, then runs Cucumber, Pact, feature analysis, and PR drift checks.
- **Dispatch inputs:** None.
- **Permissions and configuration:** No permissions block; repository/organization `GITHUB_TOKEN` defaults apply. References `PACT_BROKER_URL` and `PACT_BROKER_TOKEN`, but actual Pact publishing is commented out. No environment is declared.
- **Outputs and artifacts:** Uploads `cucumber-results` after the Cucumber job; writes contract coverage summary. PR runs may add a contract analysis comment.
- **Failure, retry, and rerun:** Missing Cucumber/Pact scripts are treated as no tests configured; missing spec files are silently skipped, missing Gherkin linter skips syntax validation, and business-rule coverage/breaking-change checks contain placeholders. The commented broker publish does not publish contracts. PR comment API calls need suitable issue permissions. Reruns may post another comment; inspect logs and the summary for skipped checks.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when path filters, contract types, scripts, broker integration, PR comments, permissions, artifacts, or validation placeholders change.

### `copilot-setup-steps.yml`

- **Purpose and trigger:** Manually dispatches a minimal setup workflow for the Copilot Cloud Agent environment; checks out the repository and installs Node.js 22 (including `npx`).
- **Dispatch inputs:** None.
- **Permissions and configuration:** Workflow and job permissions: `id-token: write`, `contents: read`. Uses environment `copilot`. No custom secret or variable is referenced.
- **Outputs and artifacts:** No declared outputs or artifacts; only prepares Node.js.
- **Failure, retry, and rerun:** Checkout or Node setup failures fail the run. This YAML does not install project-specific dependencies, log in to a cloud provider, or provide a build/test result. Rerun after fixing setup errors.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when Cloud Agent prerequisites, Node version, environment, permissions, or setup steps change.

### `evolution-check.yml`

- **Purpose and trigger:** Runs Mondays at 09:00 UTC or manually. Produces dependency, code-quality, technical-debt, and architecture summaries.
- **Dispatch inputs:** `full_report` (boolean, default `false`); when true, creates a GitHub issue.
- **Permissions and configuration:** No permissions block; repository/organization token defaults apply. Issue creation requires `issues: write` when `full_report` is true. No custom secrets or environment are declared.
- **Outputs and artifacts:** Uploads `dependency-reports` containing `outdated.json` and `audit.json`; generates job summaries and may create a labeled issue.
- **Failure, retry, and rerun:** Dependency audit, test coverage, complexity, duplication, and circular-dependency commands are allowed to fail or are guarded with `|| true`; several checks are informational rather than gates. The recommendations job consumes the dependency artifact. A manual full-report rerun can create another issue; review open evolution issues first.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when schedule, report contents, repository issue permissions, artifact handoff, or `full_report` behavior changes.

### `github-issues-to-azure-boards.yml`

- **Purpose and trigger:** Runs daily at 06:00 UTC or manually. Runs [`github_issues_to_azure_boards.py`](../scripts/github_issues_to_azure_boards.py), which creates one Azure Boards work item (default `Task`) per eligible GitHub issue. It validates the work item, then comments on the issue with the work item link, closes it as `not planned`, and adds the `migrated-to-azure-boards` label. Already-closed issues (historical migration) are only commented on and labeled. Pull requests are never migrated.
- **Dispatch inputs:** `dry_run` (boolean, default `false`); `issue_state` (`open` \| `closed` \| `all`, default `open`; use `closed`/`all` once for the historical migration); `issue_numbers` (comma-separated, overrides `issue_state`); `max_issues` (default `100`).
- **Field mapping:**

  | GitHub                                                                                                        | Azure DevOps                                                                                    |
  | ------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
  | Title                                                                                                         | `System.Title` (max 255 chars)                                                                  |
  | Body + author, dates, labels, assignees, milestone header                                                     | `System.Description` (Markdown)                                                                 |
  | Labels                                                                                                        | `System.Tags` (plus `GitHub` and the trace tag `GitHub:<owner>/<repo>#<n>`)                     |
  | `P0`/`critical`, `P1`/`high` → 1; `P2`/`medium` → 2; `P3`/`low` → 3; `P4`/`trivial` → 4 (also `priority:<x>`) | `Microsoft.VSTS.Common.Priority`                                                                |
  | Open / closed `completed` / closed `not_planned`                                                              | Initial state / `AZDO_CLOSED_STATE` (default `Done`) / `AZDO_REMOVED_STATE` (default `Removed`) |
  | Assignees (via `AZDO_USER_MAP`)                                                                               | `System.AssignedTo`                                                                             |
  | Comments                                                                                                      | Work item comments (Markdown, with author, date, and original link)                             |
  | Attachments in body/comments                                                                                  | `AttachedFile` relations (best effort; the original link always stays in the text)              |
  | `#n` references, issue URLs, sub-issues                                                                       | `Related` links to the corresponding work items                                                 |
  | Issue URL                                                                                                     | `Hyperlink` relation (traceability); the issue comment links back to the work item              |

- **Permissions and configuration:** `contents: read`, `issues: write`. Required secret: `AZDO_PAT` with scope _Work Items (Read & write)_ in organization `ava-spain-setc` (rotate it before expiry; the run fails with an explicit error if it is missing). Target defaults: `AZDO_ORG_URL` = `https://dev.azure.com/ava-spain-setc`, `AZDO_PROJECT` = `BoltFramework`, `AZDO_PARENT_ID` = `38350` (migration PBI); override them with repository variables. Optional variables: `AZDO_WORK_ITEM_TYPE`, `AZDO_AREA_PATH`, `AZDO_ITERATION_PATH`, `AZDO_CLOSED_STATE`, `AZDO_REMOVED_STATE`, `AZDO_USER_MAP` (JSON `{"github-login": "user@domain"}`), `AZDO_SYNC_EXCLUDE_LABELS` (additional comma-separated labels to skip; `access-request` and `migrated-to-azure-boards` are always excluded so the SME access flow is never interrupted). Access requests are also detected without labels, from the `[Access]` title prefix, the access-request form fields (`Avanade Email`, `GitHub Username`, `Requested Access Level`), or any access-flow label (`pending-approval`, `approved-by-smes`, `access-granted`). Such issues are skipped and are re-checked right before closing. No environment is declared.
- **Outputs and artifacts:** Job summary with a per-issue validation table, plus the `azure-boards-migration-report-<run_id>` artifact (`migration-report.json`, 90-day retention). Together these are the documented validation evidence.
- **Validation:** Before closing an issue, the run checks the work item's title, label tags, trace tag, GitHub hyperlink, presence of every GitHub comment, and the expected state. If any check fails, the issue stays open, the item is marked `failed`, and the run exits with an error.
- **Failure, retry, and rerun:** Idempotent. The trace tag is used to find existing work items, so a rerun never duplicates them. On reruns it fills in missing comments and state, adds relations that were missing, and closes the issue only after validation passes. Relations to issues that are not migrated yet are reported as warnings and are added on a later run. Attachments that cannot be downloaded (for example, private `user-attachments`) produce warnings and keep the original link. Run with `dry_run: true` first.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update this entry when the field mapping, schedule, authentication, excluded labels, or close behavior changes.

### `infra-validation.yml`

- **Purpose and trigger:** Runs on pushes/PRs touching `infra/**`, `terraform/**`, `bicep/**`, `kubernetes/**`, or `helm/**`; also manual dispatch. Detects file types and runs corresponding validators, PR Terraform plan/cost checks, and a summary.
- **Dispatch inputs:** None.
- **Permissions and configuration:** No permissions block; repository/organization token defaults apply. Terraform PR plan uses environment `terraform-plan` and secrets `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`. PR cost estimation references `INFRACOST_API_KEY`. Terraform plan comments and SARIF upload require suitable issue/security-events permissions; verify repo token settings. Terraform version is 1.6.0.
- **Outputs and artifacts:** Detection job outputs presence flags for Terraform, Bicep, Kubernetes, Helm, and Docker; job summary reports validator states. Posts Terraform plan and Infracost comments on PRs. No workflow artifact upload is declared.
- **Failure, retry, and rerun:** Terraform format, Checkov, Kubernetes dry-run, KubeLinter, Kubesec, Docker Trivy, and Infracost breakdown have non-blocking/`|| true` paths. Validators are skipped when file types are absent. Terraform plan requires the environment secrets; plan output can be included in PR comments, so review it for sensitive values. Rerun after checking cloud credentials and the plan's side effects; `terraform plan` uses normal backend initialization in this job.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when path filters, IaC detectors/tools, secret/environment dependencies, PR comments, permission needs, or soft-fail behavior changes.

### `issue-access-triage.yml`

- **Purpose and trigger:** On issue open or label, sends ordinary new issues to SME triage; for `access-request`, requests approval; for `approved-by-smes`, starts the membership grant.
- **Dispatch inputs:** None. Calls `sme-approval-request.yml` and `add-to-learning-group.yml` with `issue_number` and `secrets: inherit`.
- **Permissions and configuration:** The notification job declares `issues: write`; both reusable workflows declare `issues: write` in their jobs. The access chain needs inherited `ORG_TOKEN` with scopes appropriate to listing SME members and adding organization team members. No environment is declared.
- **Outputs and artifacts:** Issue comments, labels, assignment, team membership, and issue closure are the operational outputs; no artifact upload.
- **Failure, retry, and rerun:** Jobs are gated by event action and labels. Ensure labels exist via `bootstrap-labels.yml`. Check the called workflow when a request fails. Label events raised with `GITHUB_TOKEN` may not start follow-on workflows; the approval path deliberately uses `ORG_TOKEN` to add the label. Reopening/relabeling an issue can repeat comments or access actions; inspect membership and labels before retrying.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when access labels, event predicates, reusable callers, inherited secrets, issue permissions, or access lifecycle changes.

### `release.yml`

- **Purpose and trigger:** Runs on version tags `v*.*.*` or manual dispatch. Validates SemVer, builds/tests, conditionally builds/pushes a container, optionally publishes npm, creates a GitHub Release, updates `CHANGELOG.md` through a PR, and writes summaries.
- **Dispatch inputs:** `version` (required string, e.g. `1.0.0`); `release_type` (required choice: `patch`, `minor`, `major`, `prerelease`).
- **Permissions and configuration:** Workflow permissions: `contents: write`, `packages: write`, `pull-requests: write`, `id-token: write`. Uses `GITHUB_TOKEN`; `NPM_TOKEN` is needed to publish a non-private package; `RELEASE_BOT_APP_ID` and `RELEASE_BOT_APP_PRIVATE_KEY` are required for the changelog PR approval/merge flow; `SLACK_WEBHOOK_URL` is optional. No environment is declared.
- **Outputs and artifacts:** `validate` outputs version/changelog. Uploads `dist` (5-day retention); may publish GHCR and npm packages; creates a GitHub Release with optional `.tar.gz`/`.zip` assets; updates changelog via `automation/changelog-v*` PR and writes summaries.
- **Failure, retry, and rerun:** Invalid SemVer fails validation. Tests/build are skipped if package scripts are absent; npm publish skips for absent artifact/token or a private package. Docker signing is a placeholder. Changelog update fails if App credentials are absent; PR merge can fail due to rulesets. This workflow has irreversible external side effects: inspect existing tags/releases, npm version state, image tags, changelog PRs, and branch protection before rerunning. Do not use rerun as a rollback; follow the release rollback notes in the run summary.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when release inputs, version validation, publishing targets, credentials, permissions, branch-protection behavior, artifacts, or rollback/notification paths change.

### `security-analysis.yml`

- **Purpose and trigger:** Runs on pushes/PRs to `main`, `master`, or `develop` except documentation-only paths, or manually. Detects a stack and runs SAST, SCA, secrets, infrastructure, and report generation.
- **Dispatch inputs:** `severity_threshold` (choice `critical|high|medium|low`, default `medium`); `compliance_standard` (choice `owasp|pci-dss|gdpr|soc2`, default `owasp`); `run_full_scan` (boolean, default `true`).
- **Permissions and configuration:** No workflow-level permissions. `sast-analysis` declares `contents: read`, `security-events: write`; PR comments require suitable issue permissions. Optional secret: `SEMGREP_APP_TOKEN`. Uses `.boltf/memory/constitution.md` and local action `.github/actions/setup-stack`. No environment is declared.
- **Outputs and artifacts:** Uploads `sast-results`, `sca-results`, `secrets-results`, `infrastructure-results` (30-day retention), plus `Bolt-security-report` (90 days). Writes a summary and may comment on PRs.
- **Failure, retry, and rerun:** Unknown stack skips SAST/SCA. `run_full_scan` is accepted but is only copied into an environment variable and does not gate any scan job; setting it to `false` does not reduce the scan. Many scanner commands and SARIF uploads are non-blocking. Fork PR SARIF upload is skipped. The final critical-vulnerability gate is explicitly a placeholder: it does not parse results to enforce the selected threshold. Treat reports as analysis output, not a reliable blocking security gate. Reruns are generally safe; PR comment may be repeated.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when inputs, supported stacks/tools, scanner configuration, report parser/gates, secrets, permissions, artifacts, or path filters change.

### `security-scan.yml`

- **Purpose and trigger:** Runs on pushes/PRs to `main` or `develop`, daily at 03:00 UTC, or manually. Scans source, dependencies, secrets, containers, IaC, APIs, and licenses.
- **Dispatch inputs:** None.
- **Permissions and configuration:** Workflow permissions: `contents: read`, `security-events: write`, `actions: read`; PR comments need `issues: write`. Variable `ENABLE_CODE_SCANNING` defaults to `false`, disabling CodeQL and SARIF uploads. Optional secrets: `SNYK_TOKEN`, `GITLEAKS_LICENSE`, `API_SECURITY_TOKEN`; Gitleaks is skipped without its license and API audit is skipped without its token. No environment is declared.
- **Outputs and artifacts:** Uploads SARIF to code scanning only when enabled; uploads `license-report`. Generates the security summary and may create a critical-findings issue. No other workflow artifact upload is declared.
- **Failure, retry, and rerun:** Semgrep, npm audit, and Snyk are non-blocking; CodeQL skips when disabled or no eligible source is found. TruffleHog runs on an event-specific commit range. Dependency Check, Checkov, Trivy, and Hadolint may fail the workflow. Missing optional secrets silently skip some scans; verify the run summary before treating it as a complete security assessment. Reruns may create duplicate issues if failure handling repeats.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when branch/schedule triggers, scanning tools, `ENABLE_CODE_SCANNING`, secret requirements, permission needs, or issue/report behavior changes.

### `sme-approval-request.yml`

- **Purpose and trigger:** Reusable `workflow_call` only. Checks an access issue for prior approval, posts `/approve` and `/reject` instructions, applies `pending-approval`, and assigns the SME team.
- **Dispatch inputs:** None. Caller input: required numeric `issue_number`.
- **Permissions and configuration:** Job permission: `issues: write`. Requires inherited `ORG_TOKEN` to list SME team members (`read:org`; the YAML's setup error guidance also requests `admin:org`). No environment is declared.
- **Outputs and artifacts:** No declared outputs or artifacts. Posts a comment, adds a label, and assigns issue users.
- **Failure, retry, and rerun:** Fails if `ORG_TOKEN` is missing or member lookup/assignment returns an error. An existing `approved-by-smes` label makes the workflow skip the request/comment/assignment path. Reruns are otherwise guarded against duplicate approval requests, but check current labels and assignments first.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when caller/input, access labels, team membership API, token scope, or approval instructions change.

### `sme-approve.yml`

- **Purpose and trigger:** Handles newly created issue comments beginning with `/approve` or `/reject` on issues labeled both `access-request` and `pending-approval`.
- **Dispatch inputs:** None.
- **Permissions and configuration:** Job permission: `issues: write`. Requires `ORG_TOKEN` with `repo` and `read:org` scopes to verify SME membership and add the approval label so the downstream `issues.labeled` event can fire. No environment is declared.
- **Outputs and artifacts:** `/approve` removes `pending-approval`, adds `approved-by-smes`, and comments; `/reject [reason]` removes the pending label, comments, and closes the issue. No artifacts.
- **Failure, retry, and rerun:** Non-SME comments receive an informational response; commands on other issues are ignored. Approval uses the PAT rather than `GITHUB_TOKEN` to trigger the follow-on issue-label workflow. Label removal uses `|| true`; inspect label state after partial failure before reposting a command. Repeated comments can repeat side effects.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when command syntax, team verification, token scope, label transitions, downstream trigger, or close/reject behavior changes.

### `spec-drift.yml`

- **Purpose and trigger:** Runs every Monday at 08:00 UTC or manually. Compares Markdown specs with a source-tree summary using an OpenAI-compatible chat-completions endpoint, closes prior open `spec-drift` issues, then creates a fresh issue and run summary.
- **Dispatch inputs:** `specs_path` (string, default `specs/`); `src_path` (string, default `src/`).
- **Permissions and configuration:** Workflow permissions: `contents: read`, `issues: write`. Optional variables: `AI_ENDPOINT`, `AI_MODEL` (defaults to GitHub Models and `gpt-4o`). `AI_API_KEY` is required for non-GitHub-Models endpoints; GitHub Models uses `GITHUB_TOKEN`. No environment is declared.
- **Outputs and artifacts:** Analysis report is a step output; the workflow writes an issue labeled `spec-drift` and `technical-debt`, closes previous open issues with the drift label, and writes a run summary. No artifact upload.
- **Failure, retry, and rerun:** Missing specs or source directories are reported as skipped inputs, but later analysis and issue creation still run with whatever content is available. A provider/credential error fails analysis. This is not idempotent: each successful rerun closes the prior drift issue and creates another. Check input paths and current issues before rerunning; dispatch assignment targets the initiating non-bot user.
- **Review owner and update trigger:** `@ava-group-iberiademos/boltf-smes`; update when schedules, input paths, AI endpoint/authentication, collection limits, issue lifecycle, permissions, or report format change.

## Reusable Workflow Interfaces and Callers

| Reusable workflow                                        | Interface                                                                                                 | In-repository caller                                                                                     |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| [`ci.yml`](ci.yml)                                       | `workflow_call`; no declared inputs/secrets/outputs. Caller must allow all permissions requested by jobs. | [`cd.yml`](cd.yml), passes `secrets: inherit`; skips the call when `skip_tests` is true.                 |
| [`sme-approval-request.yml`](sme-approval-request.yml)   | Required numeric input `issue_number`; uses inherited `ORG_TOKEN`; no declared outputs.                   | [`issue-access-triage.yml`](issue-access-triage.yml) when an access-request issue is opened.             |
| [`add-to-learning-group.yml`](add-to-learning-group.yml) | Required numeric input `issue_number`; uses inherited `ORG_TOKEN`; no declared outputs.                   | [`issue-access-triage.yml`](issue-access-triage.yml) when an access request receives `approved-by-smes`. |

There are no other `workflow_call` entry points in the active YAML set. GitHub may also invoke these workflows from outside this repository; confirm repository usage before changing an interface.

## Manual Dispatch and Safe Reruns

1. In **Actions**, select the exact workflow and inspect the selected branch/ref before dispatch. Supply only the documented inputs. The YAML does not establish whether all workflows are enabled in repository settings.
2. Prefer **Re-run failed jobs** for diagnostic or validation runs after fixing the cause. A rerun uses the original event context and can repeat writes; it does not undo previous side effects.
3. Before rerunning a workflow that publishes, deploys, creates/closes issues, changes labels, assigns users, grants membership, or opens/merges a PR, inspect its current state and the workflow-specific warning above.
4. Do not set `cd.yml`'s `skip_tests` for staging/production as a workaround. Its conditions explicitly permit those jobs to run after CI is skipped, and the deployment steps are currently placeholders.
5. A green result does not prove an optional/skipped check passed. Inspect job/step summaries, artifacts, `continue-on-error` warnings, path filters, missing configuration, and placeholder notes before reporting a successful validation or deployment.

## Configuration Inventory

Names below are sourced from workflow YAML. This guide does not assert that a secret or variable is configured in repository or organization settings.

| Workflow(s)                                                                                           | Configuration names                                                                                                                                                                                                                           | Notes                                                                                                  |
| ----------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `agents-doc-sync.yml`                                                                                 | `AI_ENDPOINT`, `AI_MODEL`; `AI_API_KEY`, `AGENTS_DOC_SYNC_TOKEN`                                                                                                                                                                              | AI key required for non-GitHub-Models provider; custom token optional for PR creation.                 |
| `add-to-learning-group.yml`, `issue-access-triage.yml`, `sme-approval-request.yml`, `sme-approve.yml` | `ORG_TOKEN`; built-in `GITHUB_TOKEN`                                                                                                                                                                                                          | PAT permissions differ by step: team read/administration and issue/label workflow triggering.          |
| `cd.yml`                                                                                              | built-in `GITHUB_TOKEN`; environments `development`, `staging`, `production`                                                                                                                                                                  | Container push requires `packages: write`; deploy logic is placeholder.                                |
| `copilot-setup-steps.yml`                                                                             | environment `copilot`                                                                                                                                                                                                                         | No custom secret or variable referenced.                                                               |
| `evolution-check.yml`                                                                                 | built-in `GITHUB_TOKEN`                                                                                                                                                                                                                       | Creating an issue for `full_report` requires `issues: write`.                                          |
| `github-issues-to-azure-boards.yml`                                                                   | `AZDO_ORG_URL`, `AZDO_PROJECT`, `AZDO_WORK_ITEM_TYPE`, `AZDO_AREA_PATH`, `AZDO_ITERATION_PATH`, `AZDO_PARENT_ID`, `AZDO_CLOSED_STATE`, `AZDO_REMOVED_STATE`, `AZDO_USER_MAP`, `AZDO_SYNC_EXCLUDE_LABELS`; `AZDO_PAT`; built-in `GITHUB_TOKEN` | `AZDO_PAT` required; org/project/parent variables default to `ava-spain-setc`/`BoltFramework`/`38350`. |
| `infra-validation.yml`                                                                                | `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`, `INFRACOST_API_KEY`; environment `terraform-plan`                                                                                                               | ARM secrets used for Terraform PR plan; Infracost key used by cost estimation.                         |
| `release.yml`                                                                                         | `NPM_TOKEN`, `RELEASE_BOT_APP_ID`, `RELEASE_BOT_APP_PRIVATE_KEY`, `SLACK_WEBHOOK_URL`; built-in `GITHUB_TOKEN`                                                                                                                                | App credentials required by changelog PR flow; NPM and Slack configuration are conditional.            |
| `security-analysis.yml`                                                                               | `SEMGREP_APP_TOKEN`                                                                                                                                                                                                                           | Used for Semgrep; scanner commands are non-blocking.                                                   |
| `security-scan.yml`                                                                                   | `ENABLE_CODE_SCANNING`; `SNYK_TOKEN`, `GITLEAKS_LICENSE`, `API_SECURITY_TOKEN`; built-in `GITHUB_TOKEN`                                                                                                                                       | Code scanning defaults off; missing optional scanner credentials skip or soften checks.                |
| `spec-drift.yml`                                                                                      | `AI_ENDPOINT`, `AI_MODEL`, `AI_API_KEY`; built-in `GITHUB_TOKEN`                                                                                                                                                                              | AI key required for non-GitHub-Models endpoint.                                                        |
| All other catalog entries                                                                             | No custom secret or variable referenced in the YAML                                                                                                                                                                                           | `GITHUB_TOKEN` access still depends on declared permissions and repository/organization policy.        |
