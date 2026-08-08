# Data Model: Harden ADR Review PR Commentary

This feature has no persistent storage; "entities" are structures read from or produced by the review process at run time.

## ADR Front Matter (existing, read-only)

Source: YAML front matter in `docs/adr/*.md` (per [docs/adr/README.md](../../docs/adr/README.md) and `adr-0000-template.md`).

| Field | Type | Notes |
|---|---|---|
| `title` | string | Required (existing schema gate). |
| `status` | string | Required. New rule: values `Accepted` or `Approved` (case-insensitive) mark the ADR as eligible baseline material; any other value (e.g., `Proposed`, `Rejected`) is not. |
| `date` | string | Required (existing schema gate). |
| `authors` | string | Required (existing schema gate). |
| `tags` | list | Required (existing schema gate). |
| `dependencies` | list | Existing relationship metadata; unchanged by this feature. |
| `supersedes` | list | Existing relationship metadata; used to recognize explicit, declared supersession so it is not misreported as an unresolved conflict (FR-007). |
| `related_adrs` | list | Existing relationship metadata; unchanged. |
| `relationship_rationale` | string | Existing relationship metadata; unchanged. |
| `conflict_warnings` | list | Existing free-text field for authors to pre-declare known conflicts; unchanged, still authored by humans. |
| `superseded_by` | string | Existing field. New rule: a non-empty value excludes an otherwise-accepted ADR from the conflict baseline (FR-003a). |

## Accepted Baseline Entry (new, computed)

Produced by `review-adr.ps1` for each ADR file in `docs/adr/`, not persisted.

| Field | Type | Description |
|---|---|---|
| `File` | string | ADR file name. |
| `Status` | string | Raw status value read from front matter. |
| `IsAcceptedStatus` | bool | True when `Status` case-insensitively equals `Accepted` or `Approved`. |
| `SupersededBy` | string | Raw `superseded_by` value (empty string if none). |
| `IsEligibleBaseline` | bool | `IsAcceptedStatus` AND `SupersededBy` is empty — this is the "accepted baseline" set fed to conflict evaluation. |

## Conflict Finding (new, ephemeral — produced by the LLM review step per run)

| Field | Type | Description |
|---|---|---|
| `ConflictingAdr` | string | Identifier/file name of the eligible accepted ADR the proposed ADR contradicts. |
| `Explanation` | string | Plain-language description of the specific contradiction and why it blocks merge (FR-005). |

Not stored between runs; regenerated on each review invocation from the current proposed ADR content and the current eligible baseline set.

## Review Commentary (new, ephemeral — the PR comment body)

Composed, in order:

1. **Conflicts section** (optional): present only if one or more Conflict Findings exist; opens with the fixed heading `## ⚠️ Conflicts with Accepted ADRs — Do Not Merge`, followed by one entry per Conflict Finding.
2. **Standard commentary**: existing blocking/informational summary content, now constrained to final observations only (no process narration).

No new field is persisted to disk; this document is the PR comment text itself.
