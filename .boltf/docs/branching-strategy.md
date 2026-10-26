# Branching Strategy

Owner: `@ava-group-iberiademos/boltf-smes`. Review every 90 days and on affected workflow changes.
See [DevOps documentation governance](../../docs/devops-governance.md) for review records.

## Selected Model

Article XI §11.4 selects **GitHub Flow**. `main` is the only long-lived branch; all work branches are short-lived and integrated through pull requests. There is no `develop` branch.

This document is the canonical naming and lifecycle policy. Article XI selects the model; scripts and agents must follow this matrix. If a project constitution selects another strategy, amend its Article XI and this lifecycle guidance together before creating branches under the alternative model.

## Naming Matrix

Use lowercase kebab-case for `<slug>`, `<short-desc>`, and `<topic>`. Do not put `/` inside placeholders.

| Work type | Pattern | Example | Base branch |
| --- | --- | --- | --- |
| Feature | `feature/<feature-slug>` | `feature/user-authentication` | `main` |
| Bolt | `bolt/<feature-slug>/bolt-<N>-<short-desc>` | `bolt/user-authentication/bolt-1-domain` | Parent feature branch |
| Bug fix | `bugfix/<issue-id>-<short-desc>` | `bugfix/142-fix-login-timeout` | `main` |
| Hotfix | `hotfix/<issue-id>-<short-desc>` | `hotfix/318-patch-token-validation` | `main` |
| Release stabilization (only when needed) | `release/<version>` | `release/1.2.0` | `main` |
| Documentation | `docs/<issue-id-or-topic>-<short-desc>` | `docs/142-branching-policy` | `main` |
| Framework contribution | `contrib/<scope>-<name>` | `contrib/skill-browser-testing` | `main` |

The feature slug is the same value passed to `Create-NewFeature.ps1` or `create-new-feature.sh` and used for the feature spec directory. It is a human-readable feature name, not the numbered spec prefix or issue ID. Keep issue/spec IDs in commits and pull request metadata for traceability.

### Legacy Naming Exception

`feature/XXX-short-desc` is a **migration exception** for existing branches and specs whose branch name is already in use. Do not rename active branches solely to meet this policy, and do not create new branches in that format. New work uses `feature/<feature-slug>`; preserve the spec/issue ID in the pull request and commit references.

## Branch Lifecycle

| Branch | Pull request target | Merge method | Deletion | Release tagging |
| --- | --- | --- | --- | --- |
| Feature | `main` after all Bolts are complete and reviewed | Squash merge | Delete after merge | No feature tag; tag the release from the merged `main` commit |
| Bolt | Parent feature branch | Squash merge | Delete after merge | None |
| Bug fix | `main` | Squash merge | Delete after merge | Tag only when included in a release |
| Hotfix | `main` | Squash merge; complete the normal checks and review | Delete after merge | Tag the patch release from the merged `main` commit |
| Release stabilization | `main` | Squash merge fixes back to `main` | Delete after merge; retain the tag | Create annotated `vMAJOR.MINOR.PATCH` tag on the approved release commit |
| Documentation | `main` | Squash merge | Delete after merge | None |
| Framework contribution | `main` in the canonical framework repository | Squash merge | Delete after merge | None |

## Traceability and Pull Request Requirements

- Open a pull request for every branch; do not push work directly to `main`.
- Link the issue/spec and include the branch purpose in the pull request title or description. Keep Conventional Commit messages and required checks from the project constitution.
- For Bolt work, create the Bolt branch from its feature branch and merge it back there. Merge the completed feature to `main` only after its Bolts are complete and reviewed.
- Release tags use the `v` prefix and point to the approved commit on `main`. A release branch is optional stabilization work, not a permanent integration branch.
- Delete merged work branches. Never delete release tags as part of branch cleanup.

## Tool Compatibility

The PowerShell and Bash feature-creation scripts create `feature/<feature-slug>` from `main` by default. Their optional base-branch argument exists for repositories whose ratified Article XI explicitly selects a different base; it does not change the naming matrix. See [`scripts/README.md`](../scripts/README.md) for the script entry points.

`New-BoltContribution` creates `contrib/<scope>-<name>` from the current `HEAD` and does not switch branches. Run it from `main` to use the policy base; if another base is explicitly approved, target the PR to that branch instead.
