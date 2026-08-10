---
title: "ADR-0004: MySQL as Primary Datastore"
status: "Accepted"
date: "2026-07-01"
authors: "Repository Maintainers"
tags: ["architecture", "decision", "data"]
dependencies: []
supersedes: []
related_adrs: []
relationship_rationale: "Fixture representing a formerly-accepted decision that has since been superseded."
conflict_warnings: []
superseded_by: "adr-0003-accepted-baseline.md"
---

# ADR-0004: MySQL as Primary Datastore

## Status

**Accepted** (superseded by adr-0003-accepted-baseline.md)

## Context

Fixture ADR representing an accepted decision that has since been superseded and must be excluded from the conflict-detection baseline.

## Decision

All new services MUST use MySQL as the primary datastore.

## Consequences

### Positive

- **POS-001**: Standardizes on a single relational datastore (at the time this ADR was accepted).

### Negative

- **NEG-001**: This decision is no longer active; see `superseded_by`.
