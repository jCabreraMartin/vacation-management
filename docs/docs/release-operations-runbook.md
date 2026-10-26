# Release, Deployment, and Rollback Runbook

## Scope and Ownership

This is the operator runbook for the framework's current release automation and the readiness contract for consuming applications. It does not make the CD scaffold production-capable. The root package is private, has no application build script, and has no root Dockerfile; npm/container publication and runtime deployment are not applicable to this checkout. Record that scope explicitly for each release.

The review owner is `@ava-group-iberiademos/boltf-smes`. Review this runbook every 30 days and whenever release/CD workflows, publishing targets, security gates, environment protections, or recovery procedures change. Record reviews under [DevOps documentation governance](devops-governance.md). See the [workflow catalog](../.github/workflows/README.md) for interfaces and configuration and the [delivery policy](delivery-flow.md#quality-gates-and-blocking-policy) for binding gates, exceptions, and retention.

| Role | Responsibility |
| ---- | -------------- |
| Release manager | Select version and approved commit, coordinate the window, maintain the release record, and announce outcome. |
| Environment approver | Independently approve production target, immutable artifact, verification plan, and recovery readiness. The release author must not self-approve. |
| Deployment operator | Execute the approved procedure, capture commands/run URLs, monitor, and stop promotion on failure. |
| Incident commander | Authorize emergency runtime rollback, coordinate responders and communication, and own incident closure. |
| Service/data/security owners | Approve service-specific thresholds, schema/data recovery, and security decisions. Maintainers are the current fallback for unassigned owners. |

Name the actual people and backups in the release record before starting. A CODEOWNERS review request is not an environment approval or evidence that protection rules are enabled.

## Current Automation and Stop Conditions

| Surface | Actual behavior and operator constraint |
| ------- | --------------------------------------- |
| [Release](../.github/workflows/release.yml) | Tag push or manual dispatch validates a version, runs available build/tests, conditionally publishes, creates release notes/assets, and opens a changelog PR. Missing scripts/assets can be skipped. No production environment approval gates publication. |
| [CD](../.github/workflows/cd.yml) | `main` pushes select `staging`; `v*.*.*` tags select `production`; dispatch selects an explicit environment. Deploy, health/smoke checks, canary, promotion, audit, notification, and rollback are placeholders. Example URLs are not service endpoints. |
| Concurrent publication | A version-tag push triggers Release and CD independently. Both may publish images and write the same GitHub Release; there is no ordering or shared success gate. Inspect both runs and reconcile notes/digests. Do not use this path for a real application until GAP-008-REL is resolved. |
| CI/security/IaC | Some scans use `continue-on-error`, `\|\| true`, or skip guards. Security analysis's final threshold gate is a placeholder. Green does not establish that required scans passed. |
| Recovery | CD's dispatch-only `rollback` has `failure()`, no upstream `needs`, and an unresolved prepare dependency. Release's `rollback-prep` only prints advice. Neither restores a service. |

**No-go:** Do not claim deployment, verification, promotion, or recovery from a green scaffold run. A consuming application must close the applicable engineering items below and supply a rehearsed, service-specific command procedure before production use. For framework-only distribution, mark runtime stages not applicable with a reason; do not fabricate a deployment.

## Release Preparation

1. Open or update the release work item and use the [audit record](#release-and-incident-audit-record). Link included PBIs/issues, PRs, acceptance evidence, and the change window. Confirm named owners and communication channels.
2. Select an approved commit reachable from `main`, confirm PR approvals and required checks on that exact SHA, and confirm a clean worktree. Resolve every applicable missing, failed, cancelled, or inconclusive gate before publication.
3. Review individual CI, security, dependency, secret, contract, IaC, and artifact reports, including advisory failures and skipped scanners. No unresolved Critical/High findings or confirmed secrets are allowed under normal policy. A missing input may be not applicable; unavailable tooling is not a pass. Apply only the [documented exception process](delivery-flow.md#continue-on-error-and-exceptions); confirmed secrets, Critical findings, and production approval cannot be waived.
4. Choose SemVer: `PATCH` for compatible fixes, `MINOR` for compatible features, `MAJOR` for incompatible changes. Document migrations, consumer impact, and deprecations. Tags use `vMAJOR.MINOR.PATCH`; never move or reuse a published tag/version.
5. The current validator accepts only digits in three components and an optional single alphanumeric suffix, such as `1.2.3-rc1`. It does not implement full SemVer validation: dotted prereleases/build metadata are rejected and leading zeroes are not rejected. Use canonical numeric components without leading zeroes. `release_type` is descriptive, not an increment calculation or environment selector.
6. Prereleases require manual Release dispatch with `release_type=prerelease` and an explicit suffix, but remain subject to the manual-dispatch approved-SHA restriction below. Tag-push Release does not infer the prerelease flag, and npm's tag-push guard does not exclude prereleases. Do not push prerelease tags for an npm-enabled consuming project until routing/publication is corrected in GAP-008-REL. Manual dispatch skips npm publication but does not protect GHCR: the Release Docker job unconditionally publishes `latest`. Do not dispatch prereleases for Dockerfile-enabled consuming projects until GAP-008-REL prevents prereleases from updating stable image tags.
7. Confirm release credentials by name and scope without exposing values: `GITHUB_TOKEN` permissions for contents/packages/PRs; `RELEASE_BOT_APP_ID` and `RELEASE_BOT_APP_PRIVATE_KEY` for the changelog flow; `NPM_TOKEN` only for an approved public package. Verify registry ownership and App installation/ruleset permissions. Notification delivery must be confirmed separately; `SLACK_WEBHOOK_URL` is optional.

## Execute and Verify Publication

The examples below are PowerShell, run from this repository with Git and an authenticated, authorized GitHub CLI. Replace sample values with the approved record. Commands publish externally; do not execute both release paths for the same version. The workflow must be available on the default branch and the selected ref must contain the workflow.

### Select the Approved Commit

```powershell
$Version = '1.2.3'
$Tag = "v$Version"
$ApprovedSha = '<approved-full-commit-sha>'
git fetch origin main --tags
git status --short
git show --no-patch --format=fuller $ApprovedSha
git merge-base --is-ancestor $ApprovedSha origin/main
if ($LASTEXITCODE -ne 0) { throw 'Release commit is not reachable from origin/main' }
git ls-remote --tags origin "refs/tags/$Tag"
gh release view $Tag
```

Stop on a dirty worktree, ancestry failure, existing tag/release, or ambiguous lookup/authentication error. A missing release is expected only for a genuinely new version; distinguish it from an API failure.

### Choose One Release Path

Tag-driven stable release, only after reviewing the independent production-CD trigger:

```powershell
git tag -a $Tag $ApprovedSha -m "Release $Tag"
git push origin $Tag
```

Manual Release dispatch is **blocked for new versions** until GAP-008-REL binds release-tag creation to the approved SHA. Both GitHub Release steps omit `target_commitish`, so a missing version tag targets the default-branch HEAD, not necessarily the ref selected by `--ref`. This restriction also applies to manual prereleases; checking the tag after publication is not a preventive safeguard. Once corrected, confirm that the run and release tag resolve to the approved SHA. Manual dispatch does not explicitly trigger CD; never assume a tag/release created with `GITHUB_TOKEN` will trigger downstream workflows.

### Validate Distribution and Release Notes

1. Find the run by ref, commit, event, and timestamp; capture its run ID/URL. Inspect failed and skipped jobs, not just the summary. If a tag was pushed, inspect the separate CD run too.
2. Changelog generation uses non-merge commit subjects since the previous reachable tag; on a first release it takes up to 50 commits. Verify the selected comparison range against included issues. The workflow inserts a dated `Changed` section in [CHANGELOG.md](../CHANGELOG.md) through `automation/changelog-v<version>`. Review and confirm that PR actually merged; enabling auto-merge is not merge completion.
3. Check the `dist` artifact and expected GitHub assets `release-<version>.tar.gz` and `.zip`. A release without assets is allowed by automation but must be recorded as such; reject it when assets are required. With no application build, verify the tagged framework source and required framework payload instead. Do not invent a package artifact.
4. Download required assets, compute SHA-256 hashes, and attach a manifest linking each asset to the approved commit and run. Archive evidence before expiry: `dist` lasts only five days. Policy requires CI evidence for at least 90 days and release/deployment/approval/exception records for at least one year; current workflow retention does not ensure this. Use the organization's approved restricted audit archive and record its location.
5. npm publication requires a non-private package, downloaded `dist`, and `NPM_TOKEN`; a manual prerelease skips it. Inspect the publish step and registry version, not the GitHub Release outcome: the release job does not wait for npm success. Do not make this repository public just to bypass its intentional `private` flag. For applicable packages, inspect package contents and metadata before approval.
6. GHCR publication requires a root Dockerfile. Record the pushed digest and inspect registry metadata/provenance/SBOM and scan results. Release publishes version/major/minor/`latest` tags; CD uses its own metadata rules. Tags are mutable and the two builds need not match. The CD SHA image output is not proof that this exact tag was pushed. Resolve the actual digest; do not promote by an assumed tag. Cosign signing in Release is not implemented.
7. Review final GitHub release notes after both writers finish. Include version/tag/SHA, previous-version comparison, included issues, breaking changes/migrations, actual available assets and hashes/digests, scan evidence, deployment status, known issues, and recovery reference. Remove generated npm/Docker installation instructions when no corresponding package/image exists; correct the generated `<current-tag>...HEAD` comparison to `<previous-tag>...<current-tag>`. CD's migration-guide link has no target in this checkout.
8. Announce **published, not deployed** for framework distribution. Confirm changelog, asset, npm/container, and notification status separately. Before any rerun, inspect published versions, mutable registry tags, existing releases, and changelog PRs: rerun is neither idempotent publication nor rollback. Repair partial publication under release-manager approval without overwriting an immutable version.

Evidence commands (substitute the selected run and downloaded asset):

```powershell
gh run list --workflow release.yml --limit 10
$RunId = '<selected-run-id>'
gh run view $RunId --log-failed
gh run view $RunId --json url,headSha,event,status,conclusion,jobs
gh release view $Tag --json url,tagName,isPrerelease,assets,body
gh release download $Tag --dir "release-evidence/$Tag"
Get-ChildItem "release-evidence/$Tag" -File | Get-FileHash -Algorithm SHA256
```

If there are no assets, record that explicitly rather than interpreting download failure as successful verification. Store evidence outside the PR when it includes sensitive internal operational data; never archive credentials.

## Deployment Prerequisites and Approvals

For consuming applications, all prerequisites below are mandatory before enabling actual deployment. For this framework checkout, record runtime deployment as not applicable.

- Map canonical `dev` to GitHub `development`, `uat` to `staging`, and `prod` to `production`. There is no separate `pre` environment; do not silently introduce one.
- Verify GitHub environment required reviewers, prevention of self-review, deployment branch/tag restrictions, and permitted bypass actors in repository settings. Require independent production approval for the exact change and artifact. YAML environment declarations alone do not configure these protections. Release publication itself has no environment gate; record its human authorization before dispatch/tag push.
- Supply real Azure target/subscription/resource identifiers, health endpoints, least-privilege deployment identity, registry pull access, environment-scoped secrets, network access, and tested tooling. Prefer federated identity for future wiring; it is not implemented by current CD. Do not use `example.com` endpoints.
- Select and approve the rollout strategy. CD's canary text is not a selected architectural strategy. Define the real traffic switch, previous artifact/configuration, schema compatibility, migration sequence, tested backup/restore, recovery time/data-loss objectives, and operator permissions.
- Record dashboards, alert routes, baseline health, critical smoke tests, measurable go/no-go thresholds, observation duration, and owner-approved recovery commands. Missing thresholds or recovery rehearsal block production. Validate capacity and dependencies and establish a no-concurrent-change window.
- Promote the same scanned immutable artifact digest verified in UAT; do not rebuild at each environment. Current CD rebuilds and has no digest-selection input. Do not claim immutable promotion until GAP-008-REL is implemented. Serialize changes by target environment; current concurrency is per ref, not per environment.
- Keep `skip_tests=false`. Development does not depend on CI; staging/production accept skipped CI and do not explicitly require image-build success. Manually check all applicable gate outcomes; current guards are not enforcement. Record authorized exceptions only under the existing policy.

## Deployment, Verification, Monitoring, and Promotion

These are the required operator steps for an implemented consuming service, not capabilities of the current scaffold.

1. **Pre-deployment:** The operator records baseline error rate, latency, availability, dependency/data health, currently deployed digest/configuration, and backup readiness. Confirm no active incident or conflicting change. The release manager verifies gates and UAT acceptance; the environment approver records go/no-go with timestamp and exact target/digest.
2. **Start:** Announce release/version, environment, window, impact, operator, incident contact, and next update time in the recorded operations channel. Execute only the approved service-specific workflow/command. Capture run URL and actual deployment resource/revision. An echo summary is not deployment evidence.
3. **Verify:** Confirm the running digest and configuration match the approved record. Run actual readiness/liveness checks, critical-path smoke/contract tests, dependency checks, and migration/data-integrity checks. Record outputs and timestamps, redacting secrets. Any failed required check stops promotion.
4. **Monitor:** Observe the service's approved error-rate, latency, availability, saturation, security, and data-integrity thresholds for the full recorded window. If canary is selected, specify initial traffic share and require that window before each increase. CD's `sleep 30` performs no monitoring and is not a five-minute observation. Missing telemetry is a no-go.
5. **Promote:** The environment approver authorizes each protected transition based on recorded verification/telemetry and UAT acceptance. Shift traffic using the approved service command, keeping the same digest; repeat verification and monitoring at full traffic. On threshold breach, freeze promotion and enter rollback triage.
6. **Close:** Confirm stable health for the agreed window, record deployment status and actual digest, release the change lock, update release notes and the work item, and notify stakeholders. Keep the previous artifact/configuration and backups for the agreed recovery window.

For scaffold inspection only, the existing dispatch interface is:

```powershell
gh workflow run cd.yml --ref v1.2.3 -f environment=staging -f skip_tests=false
```

`development` and `production` are the other choices. This is **not** an operational deployment or rollback command. Pushing a new version tag already selects production independently of any staging dispatch. Do not execute these examples as a substitute for service implementation.

## Rollback and Incident Response

### Triggers and Authority

Stop promotion immediately on failed readiness/smoke tests, unexpected deployed digest, breached agreed SLO thresholds, missing telemetry, a confirmed security exposure, migration failure, or suspected data corruption. The operator pages the incident commander, release manager, and affected service/security/data owners and records detection time and evidence. Use the organization's incident severity policy; do not wait for a workflow to turn red.

The release manager and service owner authorize a planned rollback; during an incident the named incident commander authorizes emergency rollback under the recorded emergency-change policy. The operator executes it. Required production environment approval still applies. A schema/data restore requires the data owner's explicit authorization and a recorded recovery point/data-loss assessment. If no safe rollback exists, the incident commander chooses containment or an approved forward fix; do not blindly reverse migrations.

### Runtime Recovery

1. Freeze promotion and stop conflicting runs or operators. Cancel a still-running deployment only after checking whether an in-flight migration/resource operation can safely be interrupted. Cancellation does not undo completed actions.
2. Select the **previous verified digest** and matching configuration from the release record. Confirm registry availability, permissions, schema compatibility, backup status, and expected recovery time. Preserve the failing deployment's logs/telemetry for investigation.
3. Execute the rehearsed service-specific traffic switch or redeploy action recorded before deployment. Current CD has no usable rollback input/action; do not dispatch it expecting recovery. A checkout, image pull, release deletion, or rerun alone does not restore a running service. GAP-008-RB must supply the actual command/workflow and a non-production rehearsal before production is allowed.
4. Verify the running digest/configuration, health endpoints, critical transactions, dependencies, security state, and data integrity. Observe the full agreed recovery window. If recovery fails or exceeds the recovery objective, escalate to the incident commander and disaster-recovery procedure; do not declare success.
5. Record authorization, exact commands/actions, operator, target and restored digest, timestamps, outputs, verification, and data impact. Mark the failed release as withdrawn/not recommended in notes, preserving its tag/assets for audit. Announce recovery status and any continuing customer action.

### Framework and Package Recovery

For this repository, consumers can restore the previous approved framework version from its immutable tag/source archive. First back up the consumer's customized files, compare the affected framework files, and restore only the approved framework payload through a reviewed consumer PR. Verify framework initialization and affected automation in an isolated workspace before merging. Do not reset the consumer repository or overwrite application changes.

For an npm-enabled consuming project, pin consumers to the prior verified package version and publish any forward fix under a new version. Do not overwrite or automatically unpublish an existing version. For containers, switch the runtime to the recorded prior digest using the service's approved deployment mechanism, not a mutable `latest` tag. Removing a release or retagging an image is not a runtime rollback.

### Communication and Follow-Up

- At detection, communicate incident ID, affected environment/version, impact, frozen promotion, decision owner, and next update time. The incident commander sets the update cadence and stakeholder/customer channels; record them before deployment.
- At authorization/execution, communicate rollback target, expected interruption/data impact, approver, and start time. At recovery, report verified service status, restored identity, remaining risks, and next update or closure time. Confirm receipt; optional workflow notifications are not the incident communication plan.
- Before incident closure, link the failed release, deployment and recovery runs, timeline, findings, impact, approvals, evidence archive, and customer communication. Assign a post-incident review owner and due date, corrective engineering tasks, and recovery-rehearsal work. Track prevention and gate improvements against GAP-008 where applicable; update this runbook with lessons learned.

## Release and Incident Audit Record

Copy this structure into the release work item and link the incident record if recovery is needed. Retain it under the [minimum audit policy](delivery-flow.md#ci-evidence-and-minimum-audit-trail).

```text
Release work item / US-006 / included PBIs and PRs:
Release manager / operator / environment approver / incident commander / backups:
Version / previous version / tag / approved full commit SHA:
Source ref / environment / target resources / change window (UTC):
Required checks and run URLs / reports / skips or N/A reasons / exceptions and expiry:
Artifact names / SHA-256 hashes / container digest / registry publication evidence:
Release URL / final release notes / changelog PR and merge status:
Approval identities / decisions / timestamps / environment-protection evidence:
Previous artifact and configuration / migration compatibility / backup and recovery point:
Service deployment and rollback procedure / rehearsal evidence / recovery objectives:
Baseline / dashboards / numeric thresholds / observation window / smoke-test commands:
Deployment run / actual running digest / verification results / promotion decision:
Operations and stakeholder channels / update cadence / communication timestamps:
Incident / trigger / impact / rollback decision and authority / executed commands:
Restored artifact and configuration / recovery verification / start and finish (UTC):
Evidence archive location / retention expiry / follow-up owners and due dates:
```

## GAP-008 Engineering Work Register

All items below are **open**. These are local tracking IDs, not claimed GitHub issue or Azure Boards IDs. Link them as child engineering tasks of the canonical GAP-008 work item, preserving these IDs, before scheduling implementation. The repository maintainer coordinates assignment; the listed roles are accountable owners until named assignees are recorded. Do not close GAP-008 merely because this documentation is merged.

| Tracking ID | Owner | Engineering work and completion evidence |
| ----------- | ----- | ---------------------------------------- |
| GAP-008-DEP | Platform/service owner | Replace development/staging/production deployment placeholders and example URLs with authenticated Azure operations. Provide environment-scoped credentials and environment-level concurrency. Evidence: actual deployed revision/digest in non-production and failure propagation. |
| GAP-008-VER | Service/test owner | Implement preflight, health/smoke tests, real canary telemetry, measurable observation windows, promotion/abort logic, and full-rollout verification. Evidence: healthy and intentionally failing rollout rehearsals with promotion blocked on failure. |
| GAP-008-AUD | Release/operations owner | Replace deployment-record, team notification, and incident-ticket placeholders with durable records and confirmed delivery. Enforce evidence retention. Evidence: linked release/deployment/approval/incident chain and retained artifacts. |
| GAP-008-RB | Platform/service/data owners | Replace the unreachable rollback scaffold with an explicitly authorized recovery action accepting a known-good digest/configuration and validating upstream dependencies. Replace misleading Release rollback advice. Evidence: successful and failed recovery drills, schema safeguards, notification, and incident linkage. |
| GAP-008-GATE | Security/CI/IaC owners | Review `ci.yml`, `security-scan.yml`, `security-analysis.yml`, and `infra-validation.yml` for important `continue-on-error`, `\|\| true`, skip guards, and placeholder threshold aggregation. Make required gates fail closed; keep only labelled advisory checks non-blocking. Enforce CI/build dependencies and prohibit staging/production test bypass. Evidence: deliberately failing required scans block release/promotion while justified N/A remains explicit. |
| GAP-008-REL | Release/artifact owner | Establish one release-note/image publisher, strict SemVer/prerelease handling, approved-SHA/check validation, required publication outcomes, and build-once digest promotion. Implement or explicitly gate signing/provenance requirements and approval enforcement. Evidence: no duplicate writers, no prerelease stable publication/production routing, and identical verified digests across environments. |

The placeholder comments in [CD](../.github/workflows/cd.yml) map directly to this register. Required scans remain subject to manual evidence review and the existing blocking policy until engineering enforcement is delivered.

## Acceptance Evidence

| Acceptance criterion | Runbook evidence |
| -------------------- | ---------------- |
| SemVer, tags, changelog, artifacts, package/container publication, release notes | Release Preparation; Execute and Verify Publication. |
| Deployment prerequisites and environment approvals | Deployment Prerequisites and Approvals. |
| Pre-deployment, verification, monitoring, promotion, rollback | Deployment, Verification, Monitoring, and Promotion; Rollback and Incident Response. |
| Rollback triggers, authority, actions, communication, incident follow-up | Rollback and Incident Response; Release and Incident Audit Record. Real runtime commands remain a production prerequisite, not an invented capability. |
| CD placeholders clearly marked and tracked | GAP-008 Engineering Work Register and matching CD comments. |
