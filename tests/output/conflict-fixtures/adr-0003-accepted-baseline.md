---
title: "ADR-0003: PostgreSQL as Primary Datastore"
status: "Accepted"
date: "2026-08-01"
authors: "Repository Maintainers"
tags: ["architecture", "decision", "data"]
dependencies: []
supersedes: []
related_adrs: []
relationship_rationale: "Baseline datastore decision for conflict-detection fixtures."
conflict_warnings: []
superseded_by: ""
---

# ADR-0003: PostgreSQL as Primary Datastore

## Status

**Accepted**

## Context

Fixture ADR representing an active, accepted decision used to validate conflict-detection eligibility.

## Decision

All new services MUST use PostgreSQL as the primary datastore.

## Consequences

### Positive

- **POS-001**: Standardizes on a single relational datastore.

### Negative

- **NEG-001**: Services requiring other datastore engines must justify an exception.
