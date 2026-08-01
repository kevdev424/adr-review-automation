# ADR Creation Contract

## Purpose

This contract defines the expected input and output shape for the ADR creation workflow.

## Input

The workflow accepts the following information:
- decision_title
- context
- decision
- alternatives
- stakeholders
- existing_adr_references (optional)
- dependencies (optional)
- supersedes (optional)
- relationship_rationale (optional)
- conflict_review_notes (optional)

## Output

The workflow produces a markdown ADR document with:
- front matter containing title, status, date, authors, tags, supersedes, and superseded_by values
- a context section
- a decision section
- consequences and alternatives sections
- relationship metadata for dependencies and supersession
- warning notes for potential conflicts that require human review

## Validation Rules

- The ADR must include the required sections expected by the repository schema.
- Relationships must be traceable and explicit.
- Conflicts must be surfaced as review warnings rather than silently ignored.
