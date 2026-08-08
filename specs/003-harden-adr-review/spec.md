# Feature Specification: Harden ADR Review PR Commentary

**Feature Branch**: `003-harden-adr-review`

**Created**: 2026-08-08

**Status**: Draft

**Input**: User description: "lets update and harden the adr review skill, only comment in the PR the commentary for the ADR itself, not the reasoning. Also, if there are obvious conflicts with a proposed ADR and preexisting accepted ADRs then explicitly list them at the top of the PR comment explaining clearly why the PR should not be merged."

## Clarifications

### Session 2026-08-08

- Q: Which ADR status value(s) should count as "accepted" when checking a proposed ADR for conflicts? → A: ADRs with status "Accepted" or "Approved" (case-insensitive) count as the accepted baseline.
- Q: Should an accepted ADR that has been superseded (has a non-empty `superseded_by` field) still be used as a conflict baseline? → A: No — an accepted ADR with a non-empty `superseded_by` field is excluded from the conflict baseline; only currently-active accepted ADRs count.
- Q: Should the conflicts section use a fixed, required heading/marker text, or is any clear plain-language explanation acceptable? → A: Require a fixed, recognizable heading/marker (e.g., a literal "⚠️ Conflicts with Accepted ADRs — Do Not Merge" heading) so tooling and readers can detect it reliably.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Reviewers see only the final ADR commentary (Priority: P1)

When the automated review runs against a proposed ADR, the pull request comment shows only the final commentary about the ADR itself — its content, completeness, and quality — without exposing the reviewer's internal reasoning, working notes, or step-by-step analysis process.

**Why this priority**: Internal reasoning clutters the PR, is not actionable for authors, and can leak analysis that was never intended as reviewer output. Making the comment strictly about the ADR is the core hardening goal.

**Independent Test**: Run the review against a sample ADR and confirm the resulting PR comment contains only conclusions and observations about the ADR content, with no narration of the review process itself (e.g., no "first I checked...", "let me consider...", or similar working-notes language).

**Acceptance Scenarios**:

1. **Given** a proposed ADR is reviewed, **When** the review produces its PR comment, **Then** the comment contains only commentary about the ADR's content and quality, not a description of how the review was performed.
2. **Given** the review skill is run locally by a contributor, **When** it produces output, **Then** the output follows the same reasoning-free commentary format as the PR workflow.
3. **Given** the review finds no issues with an ADR, **When** the comment is generated, **Then** it clearly and concisely states the ADR looks acceptable without padding the comment with process narration.

---

### User Story 2 - Conflicts with accepted ADRs are flagged first and clearly (Priority: P1)

When a proposed ADR obviously conflicts with one or more already-accepted ADRs, the review comment lists each conflicting ADR at the very top of the comment, before any other commentary, and clearly explains why the conflict means the pull request should not be merged as-is.

**Why this priority**: Conflicts with accepted decisions are the highest-risk finding a reviewer can surface. Surfacing them first ensures they cannot be missed or buried under other commentary.

**Independent Test**: Submit a proposed ADR that contradicts an existing accepted ADR and confirm the PR comment opens with a distinct conflicts section naming the accepted ADR(s), describing the nature of the conflict, and stating that the PR should not be merged until resolved.

**Acceptance Scenarios**:

1. **Given** a proposed ADR conflicts with one accepted ADR, **When** the review comment is generated, **Then** the comment begins with a conflicts section naming the accepted ADR and explaining the specific contradiction and why merging would be inappropriate.
2. **Given** a proposed ADR conflicts with multiple accepted ADRs, **When** the review comment is generated, **Then** every conflicting accepted ADR is listed individually in the top section with its own explanation.
3. **Given** a proposed ADR has no conflicts with any accepted ADR, **When** the review comment is generated, **Then** no conflicts section appears, and the comment proceeds directly to the standard ADR commentary.
4. **Given** a proposed ADR explicitly declares that it supersedes an accepted ADR, **When** the review evaluates relationships, **Then** the declared supersession is not treated as an unresolved conflict.

---

### User Story 3 - Conflict findings remain advisory, not a merge blocker by themselves (Priority: P2)

The conflict listing is a prominent, clearly-worded warning within the existing informational commentary channel; it does not, by itself, change whether the automated status check blocks the merge. Human reviewers and maintainers remain responsible for deciding whether to act on the warning.

**Why this priority**: This preserves the existing separation between blocking validation (objective defects) and informational review (subjective/advisory concerns such as conflicts), avoiding surprise changes to merge-blocking behavior while still making conflicts impossible to overlook.

**Independent Test**: Confirm that a PR with a flagged conflict still shows the blocking validation check passing (when no objective defects exist) while the informational commentary check completes and posts the conflict warning.

**Acceptance Scenarios**:

1. **Given** a proposed ADR has an obvious conflict with an accepted ADR but no objective schema/structural defects, **When** the review runs, **Then** the blocking validation check still passes and the informational commentary check posts the conflict warning.
2. **Given** the conflict warning is posted, **When** a maintainer reviews the PR, **Then** the comment text itself states that the PR should not be merged until the conflict is resolved, even though the automated check does not block merge.

---

### Edge Cases

- What happens when an accepted ADR is ambiguous about scope, making a "conflict" a matter of interpretation rather than an obvious contradiction? (Only obvious, clearly-stated conflicts should be listed; ambiguous or speculative overlaps belong in the standard commentary, not the top conflicts section.)
- How does the review handle a repository with no accepted ADRs yet (e.g., only the template and proposed ADRs exist)? (No conflicts section is produced.)
- How does the review handle a proposed ADR that conflicts with another ADR that is itself still proposed (not yet accepted)? (Not treated as a blocking-style conflict; may still be mentioned in standard commentary since only accepted ADRs are grounds for the top conflicts section.)
- What happens if the underlying review tooling fails to produce output at all? (Existing fallback commentary behavior is preserved, and the fallback text must not fabricate a conflicts section that wasn't actually evaluated.)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The review skill MUST produce PR commentary that contains only final observations and conclusions about the proposed ADR's content, structure, and quality.
- **FR-002**: The review skill MUST NOT include narration of its own analysis process, intermediate reasoning, or working notes in the PR commentary output.
- **FR-003**: The review skill MUST evaluate the proposed ADR against all currently accepted ADRs in the repository — ADRs whose status field is "Accepted" or "Approved" (case-insensitive) and whose `superseded_by` field is empty — to detect obvious conflicts (direct contradictions in decisions, scope, or constraints).
- **FR-003a**: An accepted ADR with a non-empty `superseded_by` field MUST be excluded from the conflict baseline, since it no longer represents an active decision.
- **FR-004**: When one or more obvious conflicts with accepted ADRs are detected, the review commentary MUST present a distinct conflicts section as the first content in the comment, before any other commentary, opening with a fixed, recognizable heading/marker (e.g., "⚠️ Conflicts with Accepted ADRs — Do Not Merge") so the section can be reliably detected by both readers and tooling.
- **FR-005**: Each conflict entry MUST identify the specific accepted ADR in conflict and explain, in clear plain language, the nature of the contradiction and why the pull request should not be merged until it is addressed.
- **FR-006**: When no obvious conflicts are detected, the review commentary MUST NOT include a conflicts section.
- **FR-007**: An ADR that explicitly declares it supersedes an accepted ADR MUST NOT be reported as an unresolved conflict against that superseded ADR.
- **FR-008**: The conflict listing MUST remain part of the existing informational/advisory review output and MUST NOT alter the pass/fail outcome of the blocking validation check.
- **FR-009**: The review skill's commentary format (reasoning-free output, conflicts-first ordering) MUST be identical whether run locally by a contributor or by the automated PR workflow.
- **FR-010**: When the underlying review tooling fails to run, the fallback commentary MUST clearly indicate the review could not be completed and MUST NOT claim that no conflicts exist.

### Key Entities

- **Proposed ADR**: The architectural decision record under review in the pull request; has a status (e.g., Proposed) and may declare relationships (dependencies, supersedes, related ADRs) to other ADRs.
- **Accepted ADR**: An existing architectural decision record with an accepted status that represents a ratified decision a proposed ADR is checked against for conflicts.
- **Conflict Finding**: A specific, clearly-stated contradiction between a proposed ADR and one accepted ADR, including which accepted ADR is involved and why it constitutes a conflict.
- **Review Commentary**: The PR-facing output of the review process, composed of an optional conflicts section (first, if present) followed by the standard ADR commentary.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of generated PR review comments contain zero instances of process/reasoning narration (e.g., no first-person analysis narration phrases) when manually sampled.
- **SC-002**: When a proposed ADR obviously conflicts with an accepted ADR, the conflicts section appears as the first content in the PR comment in 100% of test cases.
- **SC-003**: Reviewers can identify, within the first few seconds of reading a PR comment, whether a proposed ADR has an unresolved conflict with an accepted decision, without reading the rest of the comment.
- **SC-004**: Comments generated for ADRs with no conflicts contain no conflicts section in 100% of test cases.
- **SC-005**: Local and CI-generated review commentary are indistinguishable in format for the same ADR input.

## Assumptions

- "Accepted" status is determined by the ADR's status front matter field having the value "Accepted" or "Approved" (case-insensitive) and an empty `superseded_by` field; ADRs in "Proposed" or other non-accepted states, or accepted ADRs that have since been superseded, are not conflict-check targets for the blocking-style top warning.
- "Obvious" conflicts refer to clear, directly-stated contradictions (e.g., an accepted ADR mandates X and the proposed ADR mandates not-X for the same scope), not subtle or speculative overlaps requiring deep judgment; those remain part of standard advisory commentary.
- The existing separation between the `adr-review-validation` (blocking) and `adr-review-commentary` (informational) checks from feature 002 is preserved; this feature only changes the content and ordering of the informational commentary, not the blocking check's criteria.
- The review skill continues to run via the same Copilot CLI-based mechanism used today; hardening changes the prompt/output contract, not the invocation mechanism.
