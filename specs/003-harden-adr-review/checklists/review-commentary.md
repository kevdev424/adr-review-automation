# Specification Quality Checklist: Review Commentary Format (Reasoning-Free, Conflicts-First)

**Purpose**: Validate that the requirements governing the review skill's PR commentary output — reasoning-free final observations, and conflicts-first fixed-heading formatting — are complete, unambiguous, and ready for implementation.
**Created**: 2026-08-08
**Feature**: [spec.md](../spec.md)
**Depth**: Standard | **Audience**: Author (pre-plan/pre-tasks self-check)

## Reasoning-Free Commentary Requirements

- [ ] CHK001 - Is "process/reasoning narration" defined precisely enough to distinguish it from a legitimate final observation? [Clarity, Spec §FR-002]
- [ ] CHK002 - Are concrete examples of prohibited narration phrasing documented, or only illustrative ("first I checked...")? [Ambiguity, Spec §FR-002]
- [ ] CHK003 - Is the boundary between "final observation" and "reasoning" testable without subjective judgment calls? [Measurability, Spec §FR-001]
- [ ] CHK004 - Are requirements defined for the no-issues-found case so it doesn't itself read as process narration ("I looked and found nothing")? [Coverage, Spec §US1 Scenario 3]
- [ ] CHK005 - Is the required tone/length for a no-issues comment specified, or left fully open? [Gap]
- [ ] CHK006 - Are requirements consistent between "reasoning-free" (FR-002) and the existing blocking/informational summary structure that must still be produced? [Consistency, Spec §FR-001, FR-002]

## Conflicts-First Section Requirements

- [ ] CHK007 - Is the exact required heading text/marker specified with no room for paraphrase? [Clarity, Spec §Clarifications 2026-08-08]
- [ ] CHK008 - Are requirements defined for what happens if the heading text needs to wrap/be adapted for non-Markdown rendering contexts? [Edge Case, Gap]
- [ ] CHK009 - Is the ordering requirement (conflicts section first) unambiguous when other blocking failures also need to be surfaced in the same comment? [Consistency, Spec §FR-004]
- [ ] CHK010 - Are requirements defined for how multiple conflicting ADRs are formatted relative to each other (list vs. narrative)? [Clarity, Spec §FR-005, US2 Scenario 2]
- [ ] CHK011 - Is the required content of each conflict entry (which ADR, why it conflicts, why it blocks merge) fully enumerated, or does it allow partial explanations? [Completeness, Spec §FR-005]
- [ ] CHK012 - Is the omission rule (no section when no conflicts) explicit enough to prevent an empty or placeholder section from being emitted? [Clarity, Spec §FR-006]

## Consistency with Conflict-Eligibility Rules

- [ ] CHK013 - Are the commentary formatting requirements (FR-004/005/006) consistent with the eligibility requirements (FR-003/FR-003a) about which ADRs may appear in the conflicts section? [Consistency, Spec §FR-003, FR-004]
- [ ] CHK014 - Is it specified what the commentary must do when a proposed ADR declares supersession (FR-007) — omit entirely, or mention as a non-blocking note? [Gap, Spec §FR-007]
- [ ] CHK015 - Are requirements clear on whether declared-but-invalid supersession references (pointing to a non-existent or non-accepted ADR) affect commentary content? [Edge Case, Gap]

## Local vs. CI Parity Requirements

- [ ] CHK016 - Is "identical format" between local and CI commentary (FR-009) defined with enough precision to be objectively verified (e.g., byte-for-byte vs. structurally equivalent)? [Measurability, Spec §FR-009, SC-005]
- [ ] CHK017 - Are requirements defined for acceptable differences between local and CI output (e.g., timestamps, run IDs), or does the spec imply zero variance? [Ambiguity, Spec §FR-009]

## Failure Fallback Requirements

- [ ] CHK018 - Are the fallback commentary's required contents fully specified when the review tool fails to run (FR-010)? [Completeness, Spec §FR-010]
- [ ] CHK019 - Is it explicit that the fallback text must omit the conflicts section entirely rather than emit a "conflicts unknown" variant of it? [Clarity, Spec §FR-010]

## Acceptance Criteria Quality

- [ ] CHK020 - Can SC-001 ("zero instances of process/reasoning narration") be objectively measured given only "manually sampled" as the verification method? [Measurability, Spec §SC-001]
- [ ] CHK021 - Does SC-003 ("identify within a few seconds") define a testable proxy (e.g., heading presence/position) rather than relying on subjective reviewer perception? [Measurability, Spec §SC-003]

## Notes

- Items flagged [Gap] or [Ambiguity] should be resolved via `/speckit.clarify` before proceeding to `/speckit.tasks` if they would materially change implementation of the prompt/skill contract.
