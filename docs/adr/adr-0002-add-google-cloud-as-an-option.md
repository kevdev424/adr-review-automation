---
title: "ADR-0002: Add Google Cloud as an Option"
status: "Proposed"
date: "2026-08-08"
authors: "myself"
tags: ["architecture", "decision", "cloud"]
dependencies: []
supersedes: []
related_adrs: ["adr-0001-azure-only-cloud-provider"]
relationship_rationale: "This ADR proposes allowing Google Cloud Platform as an option, which directly conflicts with the Azure-only decision in ADR-0001. It does not supersede ADR-0001; the conflict is surfaced for review rather than resolved here."
conflict_warnings:
  - "Conflicts with ADR-0001 (Standardize on Azure as the Only Cloud Provider), which explicitly disallows GCP as an approved public cloud provider. This conflict must be resolved (e.g., by amending or superseding ADR-0001) before this ADR can be accepted."
superseded_by: ""
---

# ADR-0002: Add Google Cloud as an Option

## Status

**Proposed**

## Context

The team anticipates a future need for technology or services that are only available on Google Cloud Platform (GCP). To avoid being blocked when that need arises, Google Cloud should be made available as a supported deployment/technology option alongside any existing provider(s) currently in use.

Note: [ADR-0001](adr-0001-azure-only-cloud-provider.md) already standardizes on Azure as the sole approved public cloud provider and explicitly flags GCP proposals as conflicting with that decision. This ADR is raised as a proposed change and does not resolve that conflict on its own.

## Decision

Allow Google Cloud Platform to be used as an option for infrastructure and technology going forward. Teams may adopt GCP-specific services when a capability is required that is not available (or not as suitable) on the current provider(s).

## Consequences

### Positive

- **POS-001**: Removes a potential blocker for adopting GCP-only technology when needed.
- **POS-002**: Increases flexibility to choose the best-fit cloud service for a given capability.
- **POS-003**: Positions the team to take advantage of GCP's roadmap and unique offerings going forward.

### Negative

- **NEG-001**: Directly conflicts with ADR-0001's Azure-only standardization and would require that decision to be revisited.
- **NEG-002**: Introduces multi-cloud complexity (additional accounts, IAM, billing, and operational overhead).
- **NEG-003**: Team members may need to build new skills/expertise specific to GCP.
- **NEG-004**: Risk of inconsistent tooling, monitoring, and deployment practices across providers if adoption is not governed.

## Alternatives Considered

### Remain Single-Provider Only

- **ALT-001**: **Description**: Continue restricting infrastructure and technology choices to the current cloud provider(s) per ADR-0001, declining to add Google Cloud as an option.
- **ALT-002**: **Rejection Reason**: Would block adoption of technology that may only be available on Google Cloud, limiting future flexibility.

### Adopt a Multi-Cloud Abstraction Layer

- **ALT-003**: **Description**: Introduce an abstraction layer/framework that hides provider-specific details, allowing GCP support without direct provider lock-in.
- **ALT-004**: **Rejection Reason**: Adds significant upfront complexity and tooling investment that is not currently justified; can be revisited if multi-cloud usage grows.

## Implementation Notes

- **IMP-001**: Resolve the conflict with ADR-0001 before acceptance (amend or supersede it).
- **IMP-002**: Establish a Google Cloud account/project and access controls before first use.
- **IMP-003**: Document which capabilities or services justify choosing GCP over the existing provider(s).
- **IMP-004**: Track adoption and operational overhead to confirm the decision remains justified over time.

## References

- **REF-001**: [ADR-0001: Standardize on Azure as the Only Cloud Provider](adr-0001-azure-only-cloud-provider.md)
- **REF-002**: ADR template at [adr-0000-template.md](adr-0000-template.md)
- **REF-003**: N/A

## Validation Summary

- Required metadata: PASS
- Dependency references: PASS
- Supersession references: PASS
- Circular relationship checks: PASS
- Final status: WARN (unresolved conflict with ADR-0001)
