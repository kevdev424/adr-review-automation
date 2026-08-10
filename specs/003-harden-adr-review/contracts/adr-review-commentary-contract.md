# Contract: ADR Review PR Commentary Output

This is a prompt/CLI output contract (not a network API) — it defines the required shape of text produced by the `review-adr` skill, whether invoked locally (`scripts/review-adr.sh`) or in CI (`.github/workflows/adr-review.yml`, `adr-review-commentary` job).

## Invocation

- **Local**: `scripts/review-adr.sh` → Copilot CLI using the `review-adr` skill → writes `artifacts/adr-review-summary.md`.
- **CI**: `adr-review.yml` `adr-review-commentary` job → same Copilot CLI invocation pattern → posts the output as a PR comment via `gh pr comment`.
- Both paths MUST use the same skill contract (`.agents/skills/review-adr/SKILL.md`) and produce identically structured output for the same ADR input (FR-009, SC-005).

## Output structure (Markdown)

```text
[optional conflicts section — present only if ≥1 obvious conflict with an eligible accepted ADR is found]
## ⚠️ Conflicts with Accepted ADRs — Do Not Merge

- **Conflicts with <accepted-adr-file-or-id>**: <plain-language explanation of the contradiction and why this PR should not be merged until resolved>
- **Conflicts with <accepted-adr-file-or-id>**: <...>              (one entry per conflicting accepted ADR — FR-005)

[standard commentary — always present]
## ADR Review Summary

- Blocking validation: PASS | FAIL
- Blocking findings: <list, or "none">
- Informational review: <list of final observations, or "No advisory concerns detected.">
```

## Rules

1. **Ordering (FR-004)**: If the conflicts section is present, it MUST be the first content in the output, before the `## ADR Review Summary` heading.
2. **Fixed heading (clarified 2026-08-08)**: The conflicts section MUST begin with the literal heading text `## ⚠️ Conflicts with Accepted ADRs — Do Not Merge` (case- and punctuation-exact) so it is reliably detectable by readers and tooling.
3. **Omission (FR-006)**: If no eligible accepted ADR conflicts are found, the conflicts section (including its heading) MUST be omitted entirely — never emit an empty or "no conflicts" variant of this section.
4. **Conflict eligibility (FR-003, FR-003a)**: Only ADRs with status `Accepted` or `Approved` (case-insensitive) AND an empty `superseded_by` field are valid targets for a Conflict Finding.
5. **Declared supersession (FR-007)**: If the proposed ADR's `supersedes` field names an eligible accepted ADR, that ADR MUST NOT be reported as a conflict.
5a. **Invalid supersedes reference (FR-007a)**: If the proposed ADR's `supersedes` field names an ADR that does not exist or is not an eligible accepted ADR, that entry MUST be treated as if no supersession was declared — the review MUST still evaluate the named ADR (if otherwise eligible) for conflicts normally.
6. **No process narration (FR-001, FR-002)**: The output MUST contain only final observations/conclusions about the ADR. It MUST NOT contain sentences using first-person action language describing the reviewer's own steps (e.g., "First I checked...", "Let me consider...", "I will now...") — this is the structural, testable definition of "narration" per FR-002.
6a. **No-issues statement length (FR-011)**: When no issues are found, the informational review section's no-issues statement MUST be no more than two sentences.
7. **Local/CI parity (FR-009)**: For the same ADR input, local and CI invocations MUST produce output that matches this structure identically (modulo timestamps/run metadata, if any).
8. **Failure fallback (FR-010)**: If the Copilot CLI invocation fails, the fallback text MUST state the review could not be completed and MUST NOT include a conflicts section or otherwise imply that conflicts were checked and found absent.
9. **Blocking check independence (FR-008)**: None of the above affects the exit code / pass-fail outcome of `validate-adr.ps1` or the `adr-review-validation` job; this contract governs the `adr-review-commentary` output only.

## Consumers

- `.github/workflows/adr-review.yml` (`adr-review-commentary` job) — posts this output verbatim as a PR comment via `gh pr comment --body-file`.
- `scripts/review-adr.sh` — writes this output to `artifacts/adr-review-summary.md` for local review.
- `tests/review-adr-tests.ps1` — asserts structural rules (heading presence/position/omission, eligibility filtering) against fixture-driven runs.
