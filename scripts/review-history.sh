#!/usr/bin/env bash
# Collects reviews of recently merged pull requests, so the agent can see what
# reviews caught, missed and got wrong. Only the AI reviewer and people with
# write access count: on a public repo anyone can comment, and these comments
# become instructions for future reviews.
set -euo pipefail

out="${1:?usage: review-history.sh <output-dir> [days]}"
days="${2:-7}"
repo="${GITHUB_REPOSITORY:?GITHUB_REPOSITORY must be set}"
mkdir -p "$out"
since="$(date -u -d "$days days ago" +%F)"

# ponytail: no pagination (50 PRs, 100 threads, 20 comments each); add it if a week outgrows that.
gh api graphql -f q="repo:$repo is:pr is:merged merged:>=$since" -f query='
query($q: String!) {
  search(query: $q, type: ISSUE, first: 50) {
    nodes { ... on PullRequest {
      number title url
      reviews(first: 20) { nodes { author { login } authorAssociation state body } }
      reviewThreads(first: 100) { nodes {
        isResolved isOutdated path line
        comments(first: 20) { nodes { author { login } authorAssociation body } }
      } }
    } }
  }
}' --jq '
def trusted: .author.login == "github-actions"
  or (.authorAssociation | IN("OWNER", "MEMBER", "COLLABORATOR"));
[.data.search.nodes[] | {
  number, title, url,
  reviews: [.reviews.nodes[] | select(trusted and .body != "")
    | {by: .author.login, state, body}],
  threads: [.reviewThreads.nodes[]
    | {path, line, resolved: .isResolved, outdated: .isOutdated,
       comments: [.comments.nodes[] | select(trusted) | {by: .author.login, body}]}
    | select(.comments != [])]
}]' >"$out/prs.json"

echo "Wrote $(jq length "$out/prs.json") merged pull requests since $since to $out/prs.json"
