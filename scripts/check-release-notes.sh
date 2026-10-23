#!/usr/bin/env bash
# Exits non-zero if the release for $1 has no release notes.
set -euo pipefail

tag="${1:?usage: check-release-notes.sh <tag>}"
body="$(gh release view "$tag" --json body -q .body)"

if [[ -z "${body//[[:space:]]/}" ]]; then
  echo "FAIL: $tag has no release notes"
  exit 1
fi
echo "PASS: $tag has release notes"
