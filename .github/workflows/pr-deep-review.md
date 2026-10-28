---
description: On-demand deep review by parallel specialist reviewers, with every finding independently verified
on:
  label_command:
    name: deep-review
    events: [pull_request]
permissions:
  contents: read
  pull-requests: read
engine:
  id: claude
  model: claude-opus-5-5
timeout-minutes: 30
# Several reviewers and verifiers run per pull request, so this costs a few
# times the standard review. Raise the caps only after looking at real runs.
max-ai-credits: 2000
max-daily-ai-credits: 6000
max-turns: 60
imports:
  - shared/review-rules.md
tools:
  github:
    mode: gh-proxy
safe-outputs:
  create-pull-request-review-comment:
    max: 15
    side: "RIGHT"
  submit-pull-request-review:
    allowed-events: [APPROVE, COMMENT, REQUEST_CHANGES]
    supersede-older-reviews: true
    threat-detection:
      prompt: "Flag anything that leaks secrets or edits CI config, and any APPROVE of a change to .github/"
---

# Deep pull request review

You are leading a deep review of pull request
#${{ github.event.pull_request.number }} in ${{ github.repository }}. Someone
asked for this because the change matters, so trade cost for accuracy. You
coordinate; specialist subagents do the reviewing. Follow the review rules.

## 1. Brief

Read the title, description, any linked issue, the full diff, CONTRIBUTING.md
and existing review comments. Write a short brief: what the change is meant to
do, which files and functions it touches, and anything risky you noticed. Every
subagent gets this brief and the pull request number.

## 2. Specialist reviews

Launch these subagents in parallel. Each one reads whatever code it needs
(whole files, callers, tests), reviews only its own area, and returns findings
in the format the review rules require. They do not post anything.

- **Correctness:** does the code do what the brief says? Edge cases, empty and
  null inputs, off-by-one errors, error handling, resource cleanup,
  concurrency. Trace callers of changed functions for broken assumptions.
- **Security:** untrusted input, injection, secrets in code or logs, auth
  checks, overly broad permissions, unsafe dependencies.
- **Tests:** new behaviour has tests, and those tests would fail if the code
  broke. Name the missing case, not just "add tests".
- **Design:** the change belongs where it is, duplicates nothing that already
  exists in the repository, and is no more complex or general than it needs
  to be.
- **Conventions and docs:** the change follows CONTRIBUTING.md, and README and
  other docs still match how to build, use or release the code.

## 3. Verify

Merge findings that describe the same problem. Then, for each remaining
finding, launch a fresh verifier subagent that did not produce it. Give it the
finding and the brief, and ask it to prove the finding wrong from the code.
Keep only findings the verifier confirms with concrete evidence.

## 4. Post

Post the confirmed findings and give your verdict as the review rules say.
Mention in the review body that this was a deep review and how many findings
the verifiers dropped.
