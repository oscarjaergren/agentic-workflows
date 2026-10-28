---
description: On-demand production readiness check against docs/production-readiness.md
on:
  workflow_dispatch:
permissions:
  contents: read
  pull-requests: read
  actions: read
  deployments: read
  security-events: read
engine:
  id: claude
  model: claude-sonnet-5-5
timeout-minutes: 20
max-ai-credits: 1000
max-turns: 40
steps:
  - name: Collect repository settings
    run: ./scripts/readiness-facts.sh /tmp/gh-aw/agent/readiness
    env:
      GH_TOKEN: ${{ github.token }}
tools:
  github:
    mode: gh-proxy
safe-outputs:
  create-issue:
    title-prefix: "[readiness] "
    labels: [production-readiness]
    close-older-issues: true
---

# Production readiness check

Decide whether ${{ github.repository }} is ready to run in production, using
the checklist in docs/production-readiness.md.

## Evidence

- Repository settings are already collected in `/tmp/gh-aw/agent/readiness/`,
  one JSON file per question (branch rules, branch protection, environments,
  deployments, code scanning, releases, recently merged pull requests). A file
  ending in `REQUEST FAILED` means the workflow's token could not read it.
- Everything else is in the checkout: workflows in `.github/workflows/`,
  CODEOWNERS, dependabot or renovate config, README, SECURITY.md, docs, and
  infrastructure or deploy config.

## Judging each check

For every check in the checklist, give one result:

- **Pass:** you found evidence it is met. Cite it.
- **Fail:** you found evidence it is not met, or no evidence it is.
- **Not applicable:** a **Depends** check the team chose to skip, either under
  "Our decisions" or with a clear alternative in place (for example feature
  flags instead of staging). Say what they do instead.
- **Unknown:** the evidence exists but this token cannot read it, for example
  classic branch protection without admin access. Say what a human should
  look at. If the error says the feature is not available on this plan, that
  is a **Fail**, not Unknown: the protection cannot be on.

Never fail a **Depends** check only because the repository does it
differently from the example in the checklist. Fail it only when there is no
alternative at all. Never mark a **Required** check as not applicable.

## Report

Open one issue titled "Production readiness: N of M required checks pass".
Start with a one-paragraph verdict: ready, ready with gaps, or not ready, and
the most important thing to fix first. Then one table per checklist section
with columns Check, Result, Evidence. Link to files, settings pages and
workflow runs where you can. End with the Unknown items a human should check.
