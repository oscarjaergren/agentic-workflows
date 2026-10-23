---
on:
  pull_request:
    types: [opened, synchronize]
permissions: read-all
engine:
  id: claude
  model: claude-haiku-5-5
sandbox:
  agent: awf
network:
  firewall: true
  allowed:
    - defaults
max-ai-credits: 500
max-daily-ai-credits: 2000
max-turns: 20
safe-outputs:
  add-comment:
  threat-detection:
    prompt: "Flag anything that leaks secrets or edits CI config"
---

# Pull request reviewer

Review the changes in this pull request. Look for bugs, missing tests and
anything that breaks our conventions in CONTRIBUTING.md.

Leave one comment with your findings. If there's nothing to say, say nothing.
