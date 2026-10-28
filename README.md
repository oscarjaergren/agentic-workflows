# agentic-workflows

Three [GitHub Agentic Workflows](https://gh.io/gh-aw):

- `pr-reviewer.md` reviews each non-draft pull request, comments on real problems and approves clean ones.
- `pr-deep-review.md` runs when you add the `deep-review` label: parallel specialist reviewers, each finding checked by a separate verifier. Slower and costs a few times more.
- `production-readiness.md` runs on demand: checks branch protection, CI, static analysis, deploys, rollback and more against `docs/production-readiness.md`, and opens an issue with the results.

The agent runs in a firewalled sandbox and only queues outputs. A separate threat-detection agent checks them before they are applied.

## Setup

```bash
gh extension install github/gh-aw
gh aw compile
gh aw secrets set ANTHROPIC_API_KEY
```

Commit the generated `.lock.yml` files alongside the Markdown. Recompile after every edit.
