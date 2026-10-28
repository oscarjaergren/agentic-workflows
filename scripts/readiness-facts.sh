#!/usr/bin/env bash
# Collects repository settings the agent cannot see from the checkout, one file
# per question. A failed call keeps its error text: "this token cannot see
# branch protection" is itself something the report should say.
set -euo pipefail

out="${1:?usage: readiness-facts.sh <output-dir>}"
repo="${GITHUB_REPOSITORY:?GITHUB_REPOSITORY must be set}"
mkdir -p "$out"

fetch() {
  local name="$1"; shift
  gh "$@" >"$out/$name.json" 2>&1 || echo "REQUEST FAILED" >>"$out/$name.json"
}

branch="$(gh api "repos/$repo" -q .default_branch)"

fetch repo               api "repos/$repo"
fetch branch             api "repos/$repo/branches/$branch"
fetch branch-rules       api "repos/$repo/rules/branches/$branch"
fetch branch-protection  api "repos/$repo/branches/$branch/protection"
fetch environments       api "repos/$repo/environments"
fetch deployments        api "repos/$repo/deployments?per_page=20"
fetch code-scanning      api "repos/$repo/code-scanning/analyses?per_page=5"
fetch releases           api "repos/$repo/releases?per_page=5"
fetch merged-prs         pr list --repo "$repo" --state merged --limit 30 \
                           --json number,title,author,mergedAt,reviewDecision,reviews

echo "Wrote $(ls "$out" | wc -l) files to $out"
