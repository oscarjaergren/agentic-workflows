---
description: Checks the repository against the SDLC policy every Monday and opens an issue for failures
on:
  schedule:
    - cron: "0 7 * * 1"
  workflow_dispatch:
permissions:
  contents: read
  pull-requests: read
engine:
  id: claude
  model: claude-haiku-5-5
timeout-minutes: 15
max-turns: 20
tools:
  github:
    mode: gh-proxy
mcp-scripts:
  check-release-notes:
    description: "Check that a release has release notes"
    inputs:
      tag:
        type: string
        required: true
    run: |
      ./scripts/check-release-notes.sh "$INPUT_TAG"
    env:
      # MCP scripts run outside the sandbox and get no token unless given one.
      GH_TOKEN: "${{ secrets.GITHUB_TOKEN }}"
safe-outputs:
  create-issue:
    title-prefix: "[sdlc] "
    labels: [sdlc]
    close-older-issues: true
---

# SDLC conformance check

Read the SDLC policy in docs/sdlc-policy.md and break it down into a list of
concrete checks, for example "every release has release notes" or "every PR
has at least one approving review".

For each check, decide whether ${{ github.repository }} passes or fails, and
why. Look at pull requests merged in the last 30 days and the last five
releases. Use the `check-release-notes` tool for each release.

If anything fails, open one issue with a table of checks, pass or fail, and a
link to the evidence for each failure. If everything passes, call `noop` with
the list of checks you ran.
