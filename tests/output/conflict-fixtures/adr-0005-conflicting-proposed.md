---
title: "ADR-0005: MySQL for the Reporting Service"
status: "Proposed"
date: "2026-08-08"
authors: "Fixture Author"
tags: ["architecture", "decision", "data"]
dependencies: []
supersedes: []
related_adrs: []
relationship_rationale: "Fixture ADR that obviously contradicts adr-0003-accepted-baseline.md's datastore mandate without declaring supersession."
conflict_warnings: []
superseded_by: ""
---

# ADR-0005: MySQL for the Reporting Service

## Status

**Proposed**

## Context

Fixture ADR representing a proposal that directly contradicts an active accepted decision (adr-0003-accepted-baseline.md) for the same scope, without declaring any supersession relationship.

## Decision

All new services MUST use MySQL as the primary datastore.

## Consequences

### Positive

- **POS-001**: N/A — fixture for conflict-detection testing.

### Negative

- **NEG-001**: Directly contradicts adr-0003-accepted-baseline.md's PostgreSQL mandate for the same scope.
