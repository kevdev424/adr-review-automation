# Implementation Plan: Harden ADR Review PR Commentary

**Branch**: `003-harden-adr-review` | **Date**: 2026-08-08 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/003-harden-adr-review/spec.md`

## Summary

Harden the existing ADR review skill so its PR commentary contains only final, reasoning-free observations about the proposed ADR, and so that obvious conflicts with active accepted ADRs (status `Accepted`/`Approved`, not superseded) are surfaced in a fixed, unmissable heading at the very top of the comment, explaining why the PR should not merge. The deterministic eligibility of "which ADRs count as accepted baseline" is computed by extending the existing PowerShell review script (testable, no LLM judgment needed), while the Copilot CLI continues to judge whether an obvious conflict exists and to produce the final prose — now constrained by an updated skill/prompt contract that forbids process narration and mandates conflicts-first, fixed-heading formatting. No new services, languages, or infrastructure are introduced; this is a hardening of prompt contracts and a small deterministic script extension within the existing automation stack.

## Technical Context

**Language/Version**: PowerShell 7 (`pwsh`) for automation scripts, Bash for the `scripts/review-adr.sh` local entry point, GitHub Actions YAML for CI workflows.

**Primary Dependencies**: GitHub CLI (`gh`) for PR comment posting, `@github/copilot` CLI for LLM-based ADR commentary, existing `.specify/scripts/powershell/*.ps1` helper scripts.

**Storage**: N/A — ADRs are plain Markdown files with YAML front matter under `docs/adr/`; no database.

**Testing**: Custom PowerShell test harness at `tests/review-adr-tests.ps1` (plain assertions, not Pester) run against fixtures in `tests/fixtures/adr/`.

**Target Platform**: GitHub Actions `ubuntu-latest` runners (CI) and local developer machines (Windows/macOS/Linux) invoking the same scripts via `pwsh`/`bash`.

**Project Type**: Single project — repository automation scripts, prompts, and CI workflows (no app/service).

**Performance Goals**: N/A — review runs are a one-shot CI/local step; no throughput or latency target beyond staying within normal CI step duration.

**Constraints**: Must preserve the existing two-check contract from feature 002 (`adr-review-validation` blocking, `adr-review-commentary` informational); local (`scripts/review-adr.sh`) and CI (`adr-review.yml`) paths must produce identically formatted commentary for the same input; conflict baseline eligibility (status + `superseded_by`) must be computed deterministically, not left to LLM judgment.

**Scale/Scope**: Small ADR corpus (currently 2 files under `docs/adr/`); change is scoped to the review skill prompt contract, one deterministic helper script, and the CI workflow step — no changes to ADR authoring or ruleset deployment.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I. ADR-First Implementation**: N/A trigger — this feature changes review tooling/process, not architecture requiring its own ADR; it implements governance already declared in the constitution (Principle II) rather than introducing a new architectural decision. PASS.
- **II. Consistency and Non-Contradiction**: Directly served — this feature's purpose is to make non-contradiction violations against accepted ADRs impossible to overlook. PASS.
- **III. Dependency Traceability**: Preserved — conflict detection reads existing `dependencies`/`supersedes`/`related_adrs`/`superseded_by` metadata already required by the constitution and ADR standards; no new metadata fields introduced without necessity. PASS.
- **IV. Review by Approval**: Preserved — the informational conflicts warning does not bypass or replace human approval; it strengthens the information available to the human reviewer. PASS.
- **V. Schema and Quality Gates**: Preserved — the blocking `adr-review-validation` check and `validate-adr.ps1` schema gate are untouched; this feature only changes the informational commentary. PASS.

No violations. Complexity Tracking table not needed.

## Project Structure

### Documentation (this feature)

```text
specs/003-harden-adr-review/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md         # Phase 1 output (/speckit.plan command)
├── contracts/            # Phase 1 output (/speckit.plan command)
└── tasks.md              # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
.agents/skills/review-adr/
└── SKILL.md                     # Updated: reasoning-free output + conflicts-first contract

.github/prompts/
└── review-adr.prompt.md         # Updated: same contract, for local/manual invocation

.github/workflows/
└── adr-review.yml               # Updated: Copilot CLI prompt string + no-conflict-claiming fallback text

.specify/scripts/powershell/
└── review-adr.ps1               # Extended: deterministic accepted-baseline eligibility (status + superseded_by)

scripts/
└── review-adr.sh                # Unchanged invocation shape; benefits from shared contract

tests/
├── review-adr-tests.ps1         # Extended: assertions for eligibility filtering, fixed heading contract, and supersession exclusion
└── fixtures/adr/
    ├── adr-0003-accepted-baseline.md       # New fixture: active accepted ADR (conflict baseline candidate)
    ├── adr-0004-superseded-baseline.md     # New fixture: accepted but superseded ADR (excluded from baseline)
    ├── adr-0005-conflicting-proposed.md    # New fixture: proposed ADR that obviously conflicts with adr-0003
    ├── adr-0006-clean-proposed.md          # New fixture: proposed ADR with no conflicts (US1 clean case)
    └── adr-0007-superseding-proposed.md    # New fixture: proposed ADR that declares supersedes: [adr-0003] (FR-007 exclusion case)
```

**Structure Decision**: Single-project repository automation layout (already established by features 001/002). No new top-level directories; changes are localized to the review skill prompt files, one PowerShell helper script, the CI workflow, and test fixtures/assertions.

## Complexity Tracking

*No violations — table not needed.*

