---
title: "ADR-0000: Template"
status: "Proposed"
date: "2026-08-01"
authors: "Repository Maintainers"
tags: ["architecture", "decision", "template"]
dependencies: []
supersedes: []
related_adrs: []
relationship_rationale: "This template ADR establishes a baseline structure for future ADRs and does not depend on existing decisions."
conflict_warnings: []
superseded_by: ""
---

# ADR-0000: Template

## Status

**Proposed**

## Context

This document provides a default starter template for creating new Architectural Decision Records in this repository. It is intended to be copied and adapted for real architectural decisions.

## Decision

Use this ADR as the baseline template for future ADRs. The template preserves a consistent structure for context, decision, consequences, alternatives, implementation notes, references, relationship metadata, and a validation summary.

## Consequences

### Positive

- **POS-001**: Provides a consistent starting point for ADR authors.
- **POS-002**: Makes the repository’s ADR process easier to follow and review.
- **POS-003**: Supports traceability by including relationship metadata fields.

### Negative

- **NEG-001**: The template is intentionally generic and must be tailored for each real decision.
- **NEG-002**: Some metadata fields may be unnecessary for simple ADRs.

## Alternatives Considered

### Keep the Existing ADR Format Only

- **ALT-001**: **Description**: Continue using the previous informal ADR structure.
- **ALT-002**: **Rejection Reason**: This would not provide the relationship-aware metadata or validation summary required by the repository workflow.

## Implementation Notes

- **IMP-001**: Copy this file and rename it using the repository ADR naming convention.
- **IMP-002**: Replace the placeholder content with the actual decision context and rationale.
- **IMP-003**: Update the relationship metadata and validation summary before review.

## References

- **REF-001**: Repository ADR guidance in docs/adr/README.md
- **REF-002**: ADR validation script at .specify/scripts/powershell/validate-adr.ps1

## Validation Summary

- Required metadata: PASS
- Dependency references: PASS
- Supersession references: PASS
- Circular relationship checks: PASS
- Final status: PASS
