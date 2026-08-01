# Feature Specification: ADR Review Process

**Feature Branch**: `002-adr-review-process`

**Created**: 2026-08-01

**Status**: Draft

**Input**: User description: "we need to create a review process for new ADRs. This process will take place as a pull request against the main branch. When someone uses the create skill it should create a new branch off off main with the name of the ADR as the branch name and start the work there. After the ADR is completed, they will open a pull request to the main branch which should start a review workflow enforced by github rulesets. We need ruleset code in the repo so we can deploy the ruleset using the GH cli as needed to keep it updated. the ruleset should require one human review and require the review workflow to run. The review workflow should run a new review skil using the copilot cli and give a PR comment on what it thinks about the new ADR as it relates to any conflicts or if it's incomplete. As long as the review workflow runs successfully and a human approves the PR, the merge can happen."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Create an ADR from a dedicated feature branch (Priority: P1)

When an author starts a new ADR using the repository’s creation workflow, the process creates a branch from the main branch using the ADR’s name and makes that branch the active working context for the new work.

**Why this priority**: This is the foundation of the workflow because it ensures every ADR proposal is isolated from the main branch and can be reviewed independently.

**Independent Test**: A user can start a new ADR creation flow and receive a branch that is based on the main branch and dedicated to the ADR work.

**Acceptance Scenarios**:

1. **Given** a repository maintainer starts work on a new ADR, **When** the creation workflow runs, **Then** it creates a branch from the main branch with the ADR name and begins the ADR work there.
2. **Given** the workflow is asked to create an ADR branch for a name that already exists, **When** the branch creation step runs, **Then** it provides a clear resolution path rather than silently reusing an ambiguous branch.

---

### User Story 2 - Submit a new ADR through a pull request review path (Priority: P1)

When an ADR draft is complete, the author can open a pull request against the main branch so that the repository’s review and governance rules apply before the change can be merged.

**Why this priority**: Pull requests are the primary control point for enforcing review quality and protecting the main branch.

**Independent Test**: A completed ADR can be submitted as a pull request and the repository can evaluate it against the required review process.

**Acceptance Scenarios**:

1. **Given** an ADR branch contains completed work, **When** the author opens a pull request to the main branch, **Then** the repository starts the required review workflow and applies the configured review rules.
2. **Given** the pull request is opened for a new ADR, **When** the review process begins, **Then** the repository requires both a successful automated review run and a human approval before merge is allowed.

---

### User Story 3 - Receive separate blocking validation and informational review feedback (Priority: P2)

Reviewers and authors can receive two distinct automated review outputs: a blocking validation pass that checks for objective issues such as schema problems, missing required information, or obvious incompleteness, and an informational review comment that captures opinions, potential conflicts, or stylistic concerns without preventing merge.

**Why this priority**: This separation makes the review result easy to understand and ensures objective quality issues are enforced while subjective critique remains advisory.

**Independent Test**: A pull request for a new ADR receives one blocking validation result for objective defects and one informational review comment for advisory observations.

**Acceptance Scenarios**:

1. **Given** a proposed ADR has an invalid schema, missing required sections, or obvious incompleteness, **When** the review workflow runs, **Then** it fails the blocking validation step and explains the objective issue.
2. **Given** a proposed ADR has a subjective concern such as a possible architectural conflict or a preference about phrasing, **When** the review workflow runs, **Then** it posts an informational review comment without failing the validation step.
3. **Given** a proposed ADR passes the blocking validation step, **When** the review workflow runs, **Then** it records the informational review outcome separately from the blocking result.

---

### Edge Cases

- What happens when a branch name collides with an existing branch or ADR name?
- How does the workflow behave when the automated review fails or times out?
- What happens when a pull request is opened without a human reviewer assigned?
- How does the repository handle a new ADR that appears to conflict with multiple existing ADRs?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The repository MUST support a workflow that creates a new feature branch from the main branch for each new ADR effort and uses that branch as the working context for the ADR work.
- **FR-002**: The ADR creation workflow MUST allow the branch name to be derived from the ADR name so that the branch clearly reflects the ADR being worked on.
- **FR-003**: The repository MUST support a pull request-based review path for new ADRs so that ADR changes are reviewed before they can be merged into the main branch.
- **FR-004**: The repository MUST define review governance in versioned repository configuration so that the rules can be deployed and updated consistently using repository tooling.
- **FR-005**: The review governance MUST require one human review before a new ADR pull request can be merged.
- **FR-006**: The review governance MUST require the automated review workflow to run successfully before a new ADR pull request can be merged.
- **FR-007**: The automated review workflow MUST run two distinct checks for each new ADR pull request: a blocking validation step for objective defects such as schema errors, missing required information, or obvious incompleteness, and an informational review step for advisory commentary about possible conflicts or subjective concerns.
- **FR-008**: The automated review workflow MUST publish a blocking validation result when objective issues are detected and MUST publish a separate informational review comment for advisory observations that do not block merge.
- **FR-009**: The automated review workflow MUST fail the blocking validation step when objective defects are present, while still allowing the informational review step to complete and report advisory findings.
- **FR-010**: The repository MUST allow the review rules to be updated over time without manual drift, so that the governance policy remains aligned with the current ADR process.
- **FR-011**: The review process MUST permit merge only when the blocking validation step passes, the automated review workflow has completed successfully, and at least one human reviewer has approved the pull request.

### Key Entities *(include if feature involves data)*

- **ADR Proposal**: A proposed architectural decision that is being drafted, reviewed, and ultimately merged.
- **ADR Branch**: A dedicated branch created from the main branch for the purpose of developing a specific ADR proposal.
- **Pull Request**: The review vehicle that carries the ADR proposal from the branch into the main branch.
- **Review Policy**: The repository-defined rules that govern who must review the ADR and what checks must pass before merge.
- **Automated Review Assessment**: The outcome of the automated review workflow, including any issues identified about conflicts or incompleteness.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of new ADR efforts begin from a dedicated branch created from the main branch.
- **SC-002**: 100% of completed ADR changes are submitted through a pull request before merge into the main branch.
- **SC-003**: 100% of ADR pull requests are subject to a policy that requires one human review and a successful automated review run before merge.
- **SC-004**: 100% of ADR pull requests receive a blocking validation result for objective defects and a separate informational review comment when advisory concerns are present.
- **SC-005**: 100% of ADR pull requests that fail the blocking validation step remain blocked from merge until the objective issues are resolved.

## Assumptions

- The repository uses GitHub as its collaboration platform and can host repository rules and workflow automation.
- The organization can maintain versioned workflow and ruleset configuration in the repository and deploy it through repository tooling.
- New ADRs are reviewed in the context of existing ADRs, so the review process can identify conflicts against prior decisions.
- The review workflow is expected to provide guidance for human reviewers rather than replace human judgment.
