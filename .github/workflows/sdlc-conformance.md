---
on:
  schedule:
    - cron: "0 7 * * 1"
  workflow_dispatch:
permissions: read-all
engine:
  id: claude
  model: claude-haiku-5-5
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
safe-outputs:
  create-issue:
---

# SDLC conformance check

Read the SDLC policy in docs/sdlc-policy.md and break it down into a list of
concrete checks, for example "every release has release notes" or "every PR
has at least one approving review".

For each check, decide whether this repository passes or fails, and why. Use
the `check-release-notes` tool for each of the last five releases.

Open one issue summarising any failures, with links to the evidence. If
everything passes, open nothing.
