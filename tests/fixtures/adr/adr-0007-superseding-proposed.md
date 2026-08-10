---
title: "ADR-0007: Migrate to MySQL for the Reporting Service"
status: "Proposed"
date: "2026-08-08"
authors: "Fixture Author"
tags: ["architecture", "decision", "data"]
dependencies: []
supersedes: ["adr-0003-accepted-baseline.md"]
related_adrs: []
relationship_rationale: "Fixture ADR that declares supersedes over adr-0003-accepted-baseline.md, so its contradicting decision must not be reported as an unresolved conflict."
conflict_warnings: []
superseded_by: ""
---

# ADR-0007: Migrate to MySQL for the Reporting Service

## Status

**Proposed**

## Context

Fixture ADR representing a proposal that contradicts adr-0003-accepted-baseline.md's datastore mandate but explicitly declares that it supersedes that ADR.

## Decision

All new services MUST use MySQL as the primary datastore, superseding adr-0003-accepted-baseline.md.

## Consequences

### Positive

- **POS-001**: N/A — fixture for declared-supersession exclusion testing.

### Negative

- **NEG-001**: N/A — fixture for declared-supersession exclusion testing.
