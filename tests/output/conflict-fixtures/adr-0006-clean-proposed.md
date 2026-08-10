---
title: "ADR-0006: Structured Logging Format"
status: "Proposed"
date: "2026-08-08"
authors: "Fixture Author"
tags: ["architecture", "decision", "observability"]
dependencies: []
supersedes: []
related_adrs: []
relationship_rationale: "Fixture ADR with no relationship to any accepted decision, used as the clean/no-conflicts case."
conflict_warnings: []
superseded_by: ""
---

# ADR-0006: Structured Logging Format

## Status

**Proposed**

## Context

Fixture ADR covering an unrelated concern (logging format) so it has no conflicts with any accepted ADR.

## Decision

All new services MUST emit structured JSON logs to stdout.

## Consequences

### Positive

- **POS-001**: Simplifies log aggregation and parsing.

### Negative

- **NEG-001**: N/A — fixture for reasoning-free commentary testing.
