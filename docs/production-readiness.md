# Production readiness

What the production readiness check looks for. Edit this file to change it.

**Required** checks apply to every repository. **Depends** checks are
reasonable to skip if the team chose something else on purpose. Record those
choices under "Our decisions" so the check stops flagging them.

## Our decisions

Write down deliberate choices here, with a reason. For example:

- We deploy every merge straight to production behind feature flags. We have
  no staging environment; flags and fast rollback are our safety net.

## Source control

- **Required:** The default branch is protected: no force pushes, no deletion.
- **Required:** Changes reach the default branch only through pull requests.
- **Required:** Pull requests need at least one approving review before merge.
- **Required:** CI must pass before merge (required status checks).
- **Depends:** CODEOWNERS routes changes to the people who own them.

## Build and test

- **Required:** CI builds the code and runs the tests on every pull request.
- **Depends:** Recently merged pull requests actually were reviewed and passed
  CI, not merged by an admin bypassing the rules.

## Security

- **Required:** Static analysis runs on pull requests (CodeQL or another SAST
  tool).
- **Required:** Dependency updates are automated (Dependabot or Renovate).
- **Required:** Workflows set least-privilege `permissions:` instead of
  relying on the defaults.
- **Required:** No dangerous workflow patterns: `pull_request_target` that
  checks out pull request code, or `${{ github.event.* }}` values pasted into
  `run:` scripts.
- **Depends:** Third-party actions are pinned to a commit SHA.
- **Depends:** SECURITY.md says how to report a vulnerability.

## Release and deploy

- **Required:** Deploys are automated from CI, not run by hand from a laptop.
- **Required:** There is a way to roll back, documented or automated.
- **Depends:** Changes pass through a gate before users see them: a staging
  environment, environment protection rules, canary releases or feature flags.
- **Depends:** Releases are tagged and have release notes.

## Operations

- **Required:** The README says how to build, run and deploy.
- **Depends:** Logs, metrics and alerts are set up, or documented as living
  elsewhere.
- **Depends:** There is a named owner and a runbook for when it breaks.
