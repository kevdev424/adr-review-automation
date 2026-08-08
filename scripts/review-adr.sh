#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_path="$repo_root/artifacts/adr-review-summary.md"

mkdir -p "$repo_root/artifacts"

if ! command -v copilot >/dev/null 2>&1; then
  echo "Copilot CLI was not found in PATH." >&2
  exit 1
fi

copilot run --skill "$repo_root/.agents/skills/review-adr/SKILL.md" --prompt "Review the ADR files in $repo_root/docs/adr and produce a markdown summary. Include a blocking validation section for objective defects and an informational review section for advisory comments." > "$output_path"

printf '\nReview summary written to %s\n' "$output_path"
