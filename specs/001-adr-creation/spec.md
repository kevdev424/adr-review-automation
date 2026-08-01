# Feature Specification: ADR Dependency-Aware Creation

**Feature Branch**: `001-adr-creation`

**Created**: 2026-08-01

**Status**: Draft

**Input**: User description: "starting with the skill create-architectural-decision-record, we need to modify this skill to be able to create new ADRs. Start with the schema suggested in the skill, but modify it to include additional capabilities. ADRs need to support a dependency chain, where one new ADR might depend on the decisions of zero or many other preexisting ADRs. Creating a new ADR should also take into consideration preexisting ADRs and help prevent conflicting decisions. Conflicting decisions create illogical architecture."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Create a new ADR with explicit dependencies (Priority: P1)

A repository maintainer or architect can ask the ADR creation workflow to draft a new ADR while referencing zero or many existing ADRs as dependencies. When the new ADR narrows or replaces an earlier decision, the workflow should also record that relationship as a supersession while preserving a clear dependency chain.

**Why this priority**: This is the core value of the feature because it makes new ADRs fit into the existing architecture history instead of standing alone.

**Independent Test**: A user can request a new ADR draft and receive a structured proposal that includes dependency references and a clear rationale for the selected relationships.

**Acceptance Scenarios**:

1. **Given** existing ADRs are available in the repository, **When** a user requests a new ADR draft, **Then** the workflow identifies relevant prior ADRs and includes them as dependencies when appropriate.
2. **Given** a proposed ADR has no dependency relationships, **When** the draft is created, **Then** the workflow records that the ADR has no declared dependencies rather than implying an unsupported relationship.

---

### User Story 2 - Detect and surface likely conflicts with prior ADRs (Priority: P1)

When a new ADR would contradict or narrow an existing architectural decision, the workflow should identify the conflict and surface it as a warning for explicit human review rather than silently proceeding.

**Why this priority**: Preventing contradictory architecture decisions is essential to preserve a coherent and trustworthy system design.

**Independent Test**: A user can draft an ADR that overlaps with a previous decision and receive a clear conflict warning tied to the relevant existing ADRs.

**Acceptance Scenarios**:

1. **Given** an existing ADR contains a decision that conflicts with a proposed ADR, **When** the draft is evaluated, **Then** the workflow flags the conflict and explains the affected relationship.
2. **Given** a proposed ADR is compatible with the current ADR landscape, **When** the draft is evaluated, **Then** the workflow does not raise a conflict warning.
3. **Given** a conflict warning is raised, **When** the author reviews the draft, **Then** the workflow allows the draft to continue as long as the conflict is explicitly acknowledged or resolved.

---

### User Story 3 - Preserve ADR traceability for future review (Priority: P2)

Reviewers and downstream contributors can understand how a new ADR relates to earlier decisions and whether it supersedes, extends, or depends on them.

**Why this priority**: Traceability reduces confusion during review and makes the architecture easier to maintain over time.

**Independent Test**: A reviewer can inspect a new ADR and follow the recorded dependency chain and related decision context without guessing.

**Acceptance Scenarios**:

1. **Given** a new ADR references existing ADRs, **When** it is reviewed, **Then** readers can identify the dependency chain and the reasoning behind it.
2. **Given** a new ADR changes or narrows an earlier decision, **When** it is reviewed, **Then** the relationship to the earlier ADR is explicitly visible.

---

### Edge Cases

- What happens when a proposed ADR depends on an ADR that is missing or not discoverable?
- How does the workflow handle circular dependency relationships between ADRs?
- What happens when two existing ADRs appear to support different directions for the same architectural concern?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The ADR creation workflow MUST produce an ADR document that supports dependency relationships, conflict awareness, and relationship metadata.
- **FR-002**: A new ADR MUST be able to declare zero or many dependencies on existing ADRs.
- **FR-003**: The workflow MUST review the existing ADR set when drafting a new ADR so that it can identify related decisions and potential conflicts.
- **FR-004**: The workflow MUST flag a proposed ADR when it appears to contradict an existing ADR or create an incoherent dependency chain, and it MUST present that condition as a warning for review rather than as an automatic block.
- **FR-005**: The workflow MUST preserve a traceable relationship between a new ADR and the ADRs it depends on, extends, or supersedes, including support for recording both dependency and supersession relationships when both apply.
- **FR-006**: The workflow MUST allow the author to record the rationale for dependency selection and any conflict-resolution choices.
- **FR-007**: The workflow MUST support a clear status for new ADRs that are proposed, accepted, or rejected without losing their relationship metadata.
- **FR-008**: The workflow MUST discover existing ADRs from repository files stored in docs/adr/ using the ADR naming convention adr-NNNN-[title-slug].md, or MUST clearly report that no prior ADRs were found when none exist.
- **FR-009**: The workflow MUST support repository validation of required ADR fields, dependency and supersession references, and circular relationship chains before the ADR is considered ready for review.
- **FR-010**: The workflow MUST emit a validation summary for each ADR draft that lists the status of required metadata, dependency references, supersession references, and circular-relationship checks in a consistent markdown section.
- **FR-011**: The validation summary MUST use the fixed markdown template below, with one bullet per check and a final status of PASS, WARN, or FAIL:

  - `## Validation Summary`
  - `- Required metadata: PASS|WARN|FAIL`
  - `- Dependency references: PASS|WARN|FAIL`
  - `- Supersession references: PASS|WARN|FAIL`
  - `- Circular relationship checks: PASS|WARN|FAIL`
  - `- Final status: PASS|WARN|FAIL`

### Key Entities *(include if feature involves data)*

- **ADR**: A documented architectural decision with a title, status, context, decision, consequences, and relationship metadata.
- **ADR Dependency**: A recorded relationship showing that one ADR relies on or is informed by another ADR.
- **Conflict Signal**: A warning that indicates a proposed ADR may contradict or undermine an existing ADR.
- **Decision Chain**: The ordered set of ADR relationships that explains how architectural decisions build on one another.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of newly created ADRs include explicit relationship metadata when they depend on or relate to existing ADRs.
- **SC-002**: 100% of ADR drafts that would create a clear conflict with an existing ADR are flagged with a review warning before final approval.
- **SC-003**: Reviewers can identify the dependency chain and any supersession relationships for a new ADR in less than 1 minute during a standard review.
- **SC-004**: At least 90% of new ADRs that affect an architectural area already covered by prior ADRs reference those prior decisions in the draft.
- **SC-005**: 100% of ADR drafts prepared for review include a validation summary showing that required metadata, dependency references, supersession references, and circular-relationship checks were evaluated.

## Assumptions

- Existing ADRs are available and discoverable in the repository when a new ADR is created, and they are stored in docs/adr/ using the convention adr-NNNN-[title-slug].md.
- A new ADR may depend on zero or many prior ADRs, and the workflow should support both cases.
- Conflict detection is intended to prevent illogical architecture and should surface issues for human review rather than silently accepting contradictory decisions.
- The feature is focused on improving ADR creation quality and governance rather than changing the repository’s overall review process.
