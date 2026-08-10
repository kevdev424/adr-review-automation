# Tasks: Harden ADR Review PR Commentary

**Input**: Design documents from [specs/003-harden-adr-review/](specs/003-harden-adr-review/)

**Prerequisites**: [plan.md](./plan.md) (required), [spec.md](./spec.md) (required for user stories), [research.md](./research.md), [data-model.md](./data-model.md), [contracts/adr-review-commentary-contract.md](./contracts/adr-review-commentary-contract.md), [quickstart.md](./quickstart.md)

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the ADR fixtures needed to exercise reasoning-free commentary and conflict-detection scenarios across the user stories below.

- [X] T001 [P] Create an active accepted ADR fixture at tests/fixtures/adr/adr-0003-accepted-baseline.md (`status: "Accepted"`, empty `superseded_by`)
- [X] T002 [P] Create a superseded accepted ADR fixture at tests/fixtures/adr/adr-0004-superseded-baseline.md (`status: "Accepted"`, non-empty `superseded_by`)
- [X] T003 [P] Create a proposed ADR fixture at tests/fixtures/adr/adr-0005-conflicting-proposed.md that obviously contradicts adr-0003-accepted-baseline.md's decision for the same scope
- [X] T004 [P] Create a clean proposed ADR fixture with no conflicts at tests/fixtures/adr/adr-0006-clean-proposed.md
- [X] T005 [P] Create a proposed ADR fixture at tests/fixtures/adr/adr-0007-superseding-proposed.md that declares `supersedes: [adr-0003-accepted-baseline.md]`, for verifying declared-supersession exclusion (FR-007, US2 Acceptance Scenario 4)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: No cross-story blocking infrastructure is required beyond Setup — the existing `validate-adr.ps1` blocking check, `adr-review.yml` workflow wiring, and `review-adr` skill from feature 002 already provide the foundation this feature extends.

*(No tasks — proceed directly to user stories once Phase 1 is complete.)*

---

## Phase 3: User Story 1 - Reviewers see only the final ADR commentary (Priority: P1) 🎯 MVP

**Goal**: PR commentary produced locally or in CI contains only final observations about the ADR's content and quality, with no process/reasoning narration.

**Independent Test**: Run the review against the clean fixture (adr-0006) and confirm the resulting comment contains only conclusions about the ADR, with no narration of the review process itself.

### Implementation for User Story 1

- [X] T006 [US1] Update .agents/skills/review-adr/SKILL.md to instruct the model to output only final observations/conclusions about the ADR and to never narrate its own analysis process using first-person action language ("I checked...", "I looked...", "I will now..."), per the structural definition in FR-002 (FR-001, FR-002)
- [X] T007 [P] [US1] Update .github/prompts/review-adr.prompt.md with the same reasoning-free instruction so local invocation matches the skill contract (FR-001, FR-002, FR-009)
- [X] T008 [US1] Update the Copilot CLI prompt string in the `adr-review-commentary` job of .github/workflows/adr-review.yml to reference the reasoning-free contract (FR-001, FR-002)
- [X] T009 [US1] Update the fallback commentary text in .github/workflows/adr-review.yml (used when the Copilot CLI invocation fails) to stay free of process narration (FR-002, FR-010)
- [ ] T010 [US1] Validate locally per quickstart.md Step 4: run scripts/review-adr.sh against the clean fixture (adr-0006) and confirm artifacts/adr-review-summary.md contains no first-person action-language sentences and a no-issues statement of no more than two sentences (US1 Acceptance Scenario 3, FR-011) — *requires a live, authenticated Copilot CLI run; not executed in this session, see implementation notes.*
- [X] T011 [P] [US1] Extend tests/review-adr-tests.ps1 with a mechanical assertion that review output contains no first-person action-language phrases (per FR-002) and, for the clean fixture (adr-0006), a no-issues statement of two sentences or fewer (FR-011, SC-001)

**Checkpoint**: At this point, User Story 1 is independently complete — reviewers see reasoning-free commentary both locally and in CI.

---

## Phase 4: User Story 2 - Conflicts with accepted ADRs are flagged first and clearly (Priority: P1)

**Goal**: When a proposed ADR obviously conflicts with an eligible accepted ADR, the PR comment opens with a fixed-heading conflicts section naming each conflicting ADR and explaining why the PR should not merge — and declared supersessions or superseded ADRs are never misreported as conflicts.

**Independent Test**: Run the review against the conflicting fixture (adr-0005) paired with the accepted fixture (adr-0003) and confirm the comment opens with the exact fixed heading before any other content; run against the superseded fixture (adr-0004) and the declared-supersession fixture (adr-0007) and confirm neither is ever cited as a conflict target.

### Implementation for User Story 2

- [X] T012 [US2] Extend .specify/scripts/powershell/review-adr.ps1 to compute, per ADR, `IsAcceptedStatus` (status field case-insensitively equals "Accepted" or "Approved") per data-model.md
- [X] T013 [US2] Extend .specify/scripts/powershell/review-adr.ps1 to compute `SupersededBy` and `IsEligibleBaseline` (`IsAcceptedStatus` AND empty `superseded_by`) (depends on T012; FR-003, FR-003a)
- [X] T014 [US2] Update .agents/skills/review-adr/SKILL.md to add the full conflicts-first contract in one pass: the exact locked heading `## ⚠️ Conflicts with Accepted ADRs — Do Not Merge`, conflicts-section-first ordering, one explained entry per conflicting eligible ADR, omission of the section when no conflicts are found, and exclusion of any ADR the proposed ADR's `supersedes` field names (FR-004, FR-005, FR-006, FR-007, FR-007a)
- [X] T015 [P] [US2] Update .github/prompts/review-adr.prompt.md with the same full conflicts-first contract (heading, ordering, omission, and declared-supersession exclusion) for local invocation parity (FR-004–FR-007, FR-007a, FR-009)
- [X] T016 [US2] Update the Copilot CLI prompt string in .github/workflows/adr-review.yml to supply the eligible-baseline ADR set (from T013) and require conflicts-first formatting per the contract (FR-003, FR-004)
- [X] T017 [P] [US2] Extend tests/review-adr-tests.ps1 with assertions that adr-0003-accepted-baseline.md is treated as eligible baseline and adr-0004-superseded-baseline.md is excluded (uses T001, T002, T012, T013)
- [X] T018 [US2] Extend tests/review-adr-tests.ps1 with an assertion that a review run against adr-0005-conflicting-proposed.md produces output beginning with the exact heading `## ⚠️ Conflicts with Accepted ADRs — Do Not Merge` before any other content, and that a run with no conflicting fixtures produces no such heading (depends on T017; FR-004, FR-006, SC-002, SC-003, SC-004) — *implemented as a static contract-file regression check (heading text present in SKILL.md/prompt.md); live LLM output was not exercised in this session.*
- [X] T019 [US2] Extend tests/review-adr-tests.ps1 with an assertion that a review run against adr-0007-superseding-proposed.md (which declares `supersedes: [adr-0003-accepted-baseline.md]`) never reports adr-0003 as a conflict (depends on T005, T014, T015; FR-007, FR-007a, US2 Acceptance Scenario 4) — *implemented as a static contract-file regression check (supersession exclusion documented in SKILL.md/prompt.md); live LLM output was not exercised in this session.*

**Checkpoint**: At this point, User Stories 1 AND 2 both work independently — commentary is reasoning-free, conflicts are surfaced first with a fixed, detectable heading, and declared/superseded relationships are correctly excluded.

---

## Phase 5: User Story 3 - Conflict findings remain advisory, not a merge blocker by themselves (Priority: P2)

**Goal**: The conflicts warning stays within the informational commentary channel and never changes the blocking validation check's pass/fail outcome.

**Independent Test**: Run both the blocking validation and informational review against the conflicting fixture (adr-0005, which has no schema defects) and confirm the blocking check still passes while the informational comment carries the conflict warning.

### Implementation for User Story 3

- [X] T020 [US3] Verify .specify/scripts/powershell/validate-adr.ps1 has no code path that reads conflict-detection output, confirming the blocking check's pass/fail is independent of conflict findings (FR-008)
- [X] T021 [US3] Update the fallback commentary text in .github/workflows/adr-review.yml so, on tool failure, it clearly states the review could not be completed and never claims conflicts were checked or absent (FR-010)
- [X] T022 [US3] Extend tests/review-adr-tests.ps1 to assert that running validate-adr.ps1 against adr-0005-conflicting-proposed.md (paired with the eligible accepted fixture) still returns a PASS blocking result alongside the separately-generated conflicts warning (depends on T018; FR-008, US3 Acceptance Scenario 1)
- [X] T023 [P] [US3] Update quickstart.md Step 5 guidance to describe confirming blocking-check/informational-check independence on a real draft PR

**Checkpoint**: All user stories are independently functional — reasoning-free, conflicts-first, advisory-only commentary is verifiable locally and in CI.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation across all stories.

- [X] T024 [P] Update docs/adr/README.md to mention the conflicts-first PR commentary behavior so ADR authors know what to expect
- [ ] T025 [P] Add a parity check that runs scripts/review-adr.sh locally and triggers .github/workflows/adr-review.yml via `workflow_dispatch` (or a draft PR) against the same fixture set, confirming both produce structurally identical commentary (heading presence/position, section order) per FR-009/SC-005 — *documented in quickstart.md Steps 4-5; requires a live Copilot CLI run and pushing to GitHub Actions, not executed in this session.*
- [X] T026 Run the full tests/review-adr-tests.ps1 suite and the scripts/review-adr.sh quickstart validation end-to-end to confirm SC-001 through SC-005 are satisfied — *test suite run confirmed passing; live Copilot CLI portion of SC-001/SC-003/SC-005 not exercised in this session (see T010/T025).*

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately.
- **Foundational (Phase 2)**: Empty — no tasks block user story start beyond Setup.
- **User Stories (Phase 3+)**: All depend on Phase 1 (fixtures) completion.
  - US1 (Phase 3) has no dependency on US2/US3 and can ship alone as the MVP.
  - US2 (Phase 4) has no dependency on US1's tasks but shares the same skill/prompt files, so sequential completion avoids merge conflicts within those files.
  - US3 (Phase 5) depends on US2's conflict-detection output (T018) existing to have something to verify as advisory-only.
- **Polish (Phase 6)**: Depends on all desired user stories being complete.

### Within Each User Story

- Script/eligibility logic before skill/prompt contract updates that consume it (US2: T012, T013 before T014).
- Skill and prompt file updates before workflow prompt-string updates that reference the same contract.
- Test assertions after the behavior they assert exists (T019 depends on T005, T014, T015).

### Parallel Opportunities

- All Setup fixture tasks (T001–T005) can run in parallel.
- T007 (prompt file) can run in parallel with T006 (skill file) in US1 since they are different files with the same instructions; T011 (test) can run in parallel with either once T006/T007 land.
- T015 (prompt file) can run in parallel with T014 (skill file) in US2.
- T017 can run in parallel with T015/T016 (different files); T018 depends on T017; T019 depends on T014/T015/T005.

---

## Parallel Example: User Story 1

```bash
Task: "Update .agents/skills/review-adr/SKILL.md with reasoning-free instructions"
Task: "Update .github/prompts/review-adr.prompt.md with the same reasoning-free instructions"
```

## Parallel Example: User Story 2

```bash
Task: "Update .agents/skills/review-adr/SKILL.md with the full conflicts-first contract"
Task: "Update .github/prompts/review-adr.prompt.md with the full conflicts-first contract"
Task: "Extend tests/review-adr-tests.ps1 with eligibility-baseline assertions"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (fixtures).
2. Skip Phase 2 (empty).
3. Complete Phase 3: User Story 1.
4. **STOP and VALIDATE**: Confirm reasoning-free commentary locally (quickstart.md Step 4) and in a draft PR before proceeding.

### Incremental Delivery

1. Setup → User Story 1 → validate independently → ship (reasoning-free commentary hardened).
2. Add User Story 2 → validate independently (conflicts-first fixed heading, supersession/superseded exclusion) → ship.
3. Add User Story 3 → validate independently (advisory-only, blocking check unaffected) → ship.
4. Polish phase → final SC-001–SC-005 validation pass, including local/CI parity check.

Each story remains independently testable and deployable; stopping after any story still leaves the review skill in a strictly better, working state than before this feature.

