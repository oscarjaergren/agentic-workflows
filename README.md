# agentic-workflows

Two [GitHub Agentic Workflows](https://gh.io/gh-aw):

- `pr-reviewer.md` reviews each pull request and leaves one comment.
- `sdlc-conformance.md` turns `docs/sdlc-policy.md` into checks every Monday and opens an issue for failures.

The agent runs in a firewalled sandbox and only queues outputs. A separate threat-detection agent checks them before they are applied.

## Setup

```bash
gh extension install github/gh-aw
gh aw compile
gh aw secrets set ANTHROPIC_API_KEY
```

Commit the generated `.lock.yml` files alongside the Markdown. Recompile after every edit.
