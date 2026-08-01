# Data Model: ADR Dependency-Aware Creation

## ADR

Represents a single architectural decision document.

**Fields**:
- title: human-readable ADR title
- status: Proposed, Accepted, Rejected, Superseded, or Deprecated
- date: ISO date string
- authors: one or more names or roles
- tags: classification labels such as architecture and decision
- context: problem statement and constraints
- decision: chosen approach
- consequences: positive and negative outcomes
- alternatives: options considered and why they were rejected
- implementation_notes: rollout, migration, and success guidance
- references: related standards, docs, or ADRs
- dependencies: zero or many ADR identifiers that the new ADR relies on
- supersedes: zero or many ADR identifiers that the new ADR replaces or narrows
- related_adrs: zero or many additional ADR identifiers for context
- relationship_rationale: explanation for why the selected relationships were chosen
- conflict_warnings: zero or many conflict signals discovered during drafting

## Relationship

Represents a connection between two ADRs.

**Fields**:
- source_adr: the ADR being created or updated
- target_adr: the existing ADR being referenced
- relationship_type: dependency, supersession, or extension
- rationale: why the relationship exists

## ConflictSignal

Represents a warning that a proposed ADR may contradict an existing decision.

**Fields**:
- related_adr: the ADR that may conflict
- reason: brief explanation of the potential contradiction
- severity: warning
- resolution_state: unresolved, acknowledged, or resolved

## Validation Rules

- An ADR may declare zero or many dependencies.
- An ADR may declare zero or many supersedes entries.
- A circular dependency chain should be flagged as an invalid or high-risk relationship.
- Conflicts must be represented as warnings for review, not as silent acceptance.
