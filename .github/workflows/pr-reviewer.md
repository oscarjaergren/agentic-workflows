---
description: Reviews each pull request and leaves inline comments on real problems
on:
  pull_request:
    types: [opened, synchronize, ready_for_review]
if: github.event.pull_request.draft == false
permissions:
  contents: read
  pull-requests: read
engine:
  id: claude
  model: claude-haiku-5-5
timeout-minutes: 10
max-ai-credits: 500
max-daily-ai-credits: 2000
max-turns: 20
tools:
  github:
    mode: gh-proxy
safe-outputs:
  create-pull-request-review-comment:
    max: 10
    side: "RIGHT"
  submit-pull-request-review:
    allowed-events: [COMMENT]
    supersede-older-reviews: true
    threat-detection:
      prompt: "Flag anything that leaks secrets or edits CI config"
---

# Pull request reviewer

Review pull request #${{ github.event.pull_request.number }} in ${{ github.repository }}.

1. Read the diff and the list of changed files.
2. Look only at changed lines. Flag bugs, missing tests for new behaviour, and
   anything that breaks the conventions in CONTRIBUTING.md.
3. Do not comment on style or formatting a linter would catch, or on personal
   preference. Every comment must name the file, the line and why it matters.
4. Post each finding with `create-pull-request-review-comment`, most important
   first, then submit one short review summarising them.

If there is nothing worth saying, call `noop` with one line explaining what you
checked. Do not post a review.
