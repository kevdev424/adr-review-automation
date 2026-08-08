# Tasks: ADR Review Process

**Input**: Design documents from [specs/002-adr-review-process/](specs/002-adr-review-process/)

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the repository structure needed for ADR review automation and ruleset deployment.

- [X] T001 Create the review workflow and ruleset directories under .github/ with the required file layout
- [X] T002 Create the local review script entrypoint at scripts/review-adr.sh
- [X] T003 [P] Create the PowerShell review automation script at .specify/scripts/powershell/review-adr.ps1
- [X] T004 [P] Implement ruleset deployment in .github/workflows/deploy-ruleset.yml using inline gh api

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build the shared review and governance infrastructure that must exist before the ADR review workflow can run.

- [X] T005 Add a repository ruleset definition file at .github/rulesets/adr-review-ruleset.json
- [X] T006 Add a GitHub Actions workflow at .github/workflows/adr-review.yml for PR review automation
- [X] T007 Add a GitHub Actions workflow for ruleset deployment on merges to main
- [X] T008 Create the Copilot CLI review skill definition at .specify/skills/review-adr/SKILL.md
- [X] T009 Create the review prompt file at .github/prompts/review-adr.prompt.md

---

## Phase 3: User Story 1 - Create an ADR from a dedicated feature branch (Priority: P1) 🎯 MVP

**Goal**: Ensure a new ADR starts from a dedicated branch created from main and that the branch name is derived from the ADR work.

**Independent Test**: A user can start a new ADR effort and the repository creates or uses a branch tied to the ADR work.

### Implementation for User Story 1

- [X] T010 [P] [US1] Update the branch-creation workflow or hook configuration so new ADR work starts from main on a dedicated branch
- [X] T011 [US1] Add documentation or automation guidance for deriving the branch name from the ADR title in the local workflow
- [X] T012 [US1] Verify the branch-based workflow works locally and records the selected branch context for subsequent ADR work

**Checkpoint**: At this point, new ADR work can begin from a dedicated branch created from main.

---

## Phase 4: User Story 2 - Submit a new ADR through a pull request review path (Priority: P1)

**Goal**: Ensure completed ADR work is submitted through a pull request and governed by repository rules.

**Independent Test**: A completed ADR change can be opened as a PR and is subject to the required review checks.

### Implementation for User Story 2

- [X] T013 [P] [US2] Wire the PR workflow to run for ADR-related pull requests and collect the changed ADR files
- [X] T014 [US2] Ensure the ruleset requires one human review and that the automated review workflow must complete successfully before merge
- [X] T015 [US2] Add a workflow output or summary that clearly identifies the blocking validation and informational review results for the PR

**Checkpoint**: At this point, ADR pull requests are governed by the required review policy.

---

## Phase 5: User Story 3 - Receive separate blocking validation and informational review feedback (Priority: P2)

**Goal**: Provide two distinct review outputs so objective defects block merge while advisory concerns remain informational.

**Independent Test**: An ADR PR receives a blocking validation result for objective defects and a separate informational review comment for advisory concerns.

### Implementation for User Story 3

- [X] T016 [P] [US3] Extend the existing ADR validation logic to produce a blocking validation result for schema errors, missing information, or obvious incompleteness
- [X] T017 [US3] Implement the review skill invocation so it posts an informational PR comment for advisory concerns without blocking merge
- [X] T018 [US3] Add local execution support so contributors can run the same review skill used by the pull request workflow and observe the same blocking and informational outputs locally
- [X] T019 [US3] Document the local review command and expected output format in quickstart guidance

**Checkpoint**: At this point, ADR PRs receive a clear two-step review outcome with separate blocking and informational results.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Finalize repo documentation and validation around the new ADR review workflow.

- [X] T020 [P] Update the ADR validation workflow or documentation to reflect the new review process and ruleset deployment path
- [X] T021 [P] Add or update tests or sample fixtures for the local review script and validation logic
- [X] T022 Validate the end-to-end review flow with a representative ADR change and confirm the workflow output format is consistent

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: Depend on Foundational completion
- **Polish (Phase 6)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 3 (P2)**: Can start after Foundational (Phase 2) - Can proceed independently once the validation and review hooks exist

### Parallel Opportunities

- T003 and T004 can be completed in parallel
- T010 and T011 can be completed in parallel once foundational work exists
- T013 and T015 can be completed in parallel within User Story 2
- T016 and T017 can be completed in parallel within User Story 3
