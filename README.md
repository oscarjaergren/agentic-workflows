# agentic-workflows

Four [GitHub Agentic Workflows](https://gh.io/gh-aw):

- `pr-reviewer.md` reviews each non-draft pull request, comments on real problems and approves clean ones.
- `pr-deep-review.md` runs when you add the `deep-review` label: parallel specialist reviewers, each finding confirmed by a vote of three verifiers. Slower and costs a few times more.
- `production-readiness.md` runs on demand: checks branch protection, CI, static analysis, deploys, rollback and more against `docs/production-readiness.md`, and opens an issue with the results.
- `review-lessons.md` runs weekly: reads what reviews caught, missed and got wrong, and opens a draft pull request that updates `REVIEW.md` (and `AGENTS.md` or `CLAUDE.md`). Lessons land where they stop the next mistake, not in another review round.

Both reviewers read [REVIEW.md](REVIEW.md) for what matters in this repo and how risky each kind of change is. They comment only on problems worth blocking a merge (no nits), label each pull request `risk:low`, `risk:medium` or `risk:high`, and approve only low-risk changes on their own.

The agent runs in a firewalled sandbox and only queues outputs. A separate threat-detection agent checks them before they are applied. Detection runs only on Claude or Copilot; with just a Gemini key it fails open with a warning.

## Setup

```bash
gh extension install github/gh-aw
gh aw compile
gh aw secrets set ANTHROPIC_API_KEY
```

Commit the generated `.lock.yml` files alongside the Markdown. Recompile after every edit.
