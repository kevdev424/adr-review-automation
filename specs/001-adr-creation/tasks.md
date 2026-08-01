# Tasks: ADR Dependency-Aware Creation

**Input**: Design documents from [specs/001-adr-creation/](specs/001-adr-creation/)

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare the repository artifacts and documentation structure for the ADR skill enhancement.

- [ ] T001 Create the ADR storage location and guidance file in docs/adr/README.md
- [ ] T002 Update the ADR skill extension guidance in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T003 [P] Add supporting ADR discovery and storage guidance in specs/001-adr-creation/quickstart.md

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the reusable relationship and governance structures that all ADR drafts will depend on.

- [ ] T004 Define the ADR repository discovery convention and file naming rules in specs/001-adr-creation/data-model.md
- [ ] T005 Define the ADR creation contract and expected input/output fields, including validation requirements, in specs/001-adr-creation/contracts/adr-creation-contract.md
- [ ] T006 Update the ADR skill to inspect existing ADR files in docs/adr/, include relationship metadata fields, and surface validation guidance, including the fixed validation summary template, in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T006A Implement an automated ADR validation step for schema, required fields, dependency references, supersession references, and circular-relationship integrity in the repository workflow
- [ ] T007 Document how the workflow reports missing prior ADRs and how reviewers should evaluate conflict warnings in specs/001-adr-creation/research.md

**Checkpoint**: Foundation ready - ADR drafting can now include relationship-aware metadata and conflict review guidance.

---

## Phase 3: User Story 1 - Create a new ADR with explicit dependencies (Priority: P1) 🎯 MVP

**Goal**: Enable authors to create a new ADR that records dependencies and supersession relationships in a structured way.

**Independent Test**: A user can invoke the ADR creation skill with a new decision, receive a draft, and see dependency and supersession metadata captured clearly.

### Implementation for User Story 1

- [ ] T008 [P] [US1] Extend the ADR skill prompt to accept dependency and supersedes inputs in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T009 [P] [US1] Update the ADR markdown template guidance to include dependency and supersession sections in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T010 [US1] Add relationship rationale and conflict review notes handling in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T011 [US1] Ensure new ADR drafts can explicitly state zero dependencies and preserve a traceable relationship chain in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T012 [US1] Add a validation summary section to the skill output so authors can see whether required metadata, dependency references, supersession references, and circular-relationship checks passed, using the fixed PASS/WARN/FAIL template in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T012A [US1] Wire the validation summary output to the automated validation step so the draft can report PASS/WARN/FAIL results consistently

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently.

---

## Phase 4: User Story 2 - Detect and surface likely conflicts with prior ADRs (Priority: P1)

**Goal**: Help authors identify likely conflicts with existing ADRs and surface them as review warnings.

### Implementation for User Story 2

- [ ] T013 [P] [US2] Add conflict-warning guidance to the ADR skill in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T014 [US2] Document how the workflow should report conflicting prior decisions and reviewer actions in specs/001-adr-creation/quickstart.md
- [ ] T015 [US2] Add a conflict review section to the ADR creation contract in specs/001-adr-creation/contracts/adr-creation-contract.md
- [ ] T016 [US2] Ensure the skill output can include warning text for conflicts without blocking the draft automatically in .agents/skills/create-architectural-decision-record/SKILL.md

**Checkpoint**: At this point, User Stories 1 and 2 should both work independently.

---

## Phase 5: User Story 3 - Preserve ADR traceability for future review (Priority: P2)

**Goal**: Ensure reviewers can follow the dependency chain and supersession history for each ADR.

### Implementation for User Story 3

- [ ] T017 [P] [US3] Update the ADR documentation guidance to explain traceability expectations in specs/001-adr-creation/quickstart.md
- [ ] T018 [US3] Add relationship metadata examples for dependency and supersession chains in specs/001-adr-creation/research.md
- [ ] T019 [US3] Ensure the ADR skill output includes review-friendly relationship summaries in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T020 [US3] Add a final validation note in specs/001-adr-creation/plan.md for reviewers to confirm dependency chain clarity

**Checkpoint**: All user stories should now be independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Finalize the repository guidance and documentation quality for the ADR feature.

- [ ] T021 [P] Review the ADR skill content for consistency with the repository constitution in .agents/skills/create-architectural-decision-record/SKILL.md
- [ ] T022 [P] Review the spec, plan, and checklist artifacts for alignment in specs/001-adr-creation/
- [ ] T023 Validate the quickstart flow and contract examples against the new skill behavior, including the fixed validation summary output and edge-case examples, in specs/001-adr-creation/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - blocks all user stories
- **User Stories (Phase 3+)**: All depend on Foundational completion
- **Polish (Phase 6)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - no dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational - can be implemented independently
- **User Story 3 (P2)**: Can start after Foundational - can be implemented independently

### Parallel Opportunities

- T003 can run in parallel with T001/T002
- T004 and T005 are independent foundational tasks
- T008 and T009 can be implemented in parallel within User Story 1
- T012 and T013 can be implemented in parallel within User Story 2
- T016 and T017 can be implemented in parallel within User Story 3

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Validate the new ADR draft behavior independently

### Incremental Delivery

1. Complete Setup + Foundational
2. Add User Story 1
3. Add User Story 2
4. Add User Story 3
5. Finish polish and documentation review
