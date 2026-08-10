---
title: "ADR-0001: Standardize on Azure as the Only Cloud Provider"
status: "Accepted"
date: "2026-08-08"
authors: "Repository Maintainers"
tags: ["architecture", "decision", "cloud", "infrastructure"]
dependencies: []
supersedes: []
related_adrs: []
relationship_rationale: "This ADR establishes the default cloud platform boundary and does not rely on earlier ADRs."
conflict_warnings:
  - "Any future proposal to use AWS, GCP, or another public cloud conflicts with this decision."
superseded_by: ""
---

# ADR-0001: Standardize on Azure as the Only Cloud Provider

## Status

**Proposed**

## Context

The organization needs a clear, durable cloud strategy to reduce operational sprawl, simplify procurement, and make platform engineering more predictable. Without a single approved cloud provider, teams may choose incompatible services, create duplicated skills, and introduce unnecessary complexity in security, governance, and vendor management. The decision must also preserve flexibility for locally managed datacenters where appropriate, while preventing drift toward other public clouds.

## Decision

Adopt Microsoft Azure as the one and only public cloud provider for new platform, application, and infrastructure decisions. Azure will be the default and preferred cloud platform for all new workloads. Other public cloud providers are not approved for standard use. Where operational requirements demand it, workloads may remain on locally managed datacenters, but the organization will not adopt additional public cloud providers.

## Consequences

### Positive

- **POS-001**: Simplifies procurement, licensing, and vendor governance.
- **POS-002**: Improves consistency in security controls, networking, and operational tooling.
- **POS-003**: Reduces duplicated engineering effort and lowers the cost of training and support.
- **POS-004**: Makes architecture reviews and platform standards easier to enforce.

### Negative

- **NEG-001**: Limits flexibility to use best-of-breed services from other cloud providers.
- **NEG-002**: May require rework or migration for teams already invested in non-Azure platforms.
- **NEG-003**: Creates some lock-in risk to Azure-specific services and implementation patterns.
- **NEG-004**: Local datacenter usage may still require additional operational discipline and governance.

## Alternatives Considered

### Multi-Cloud Strategy

- **ALT-001**: **Description**: Use Azure, AWS, and Google Cloud Platform interchangeably based on workload needs.
- **ALT-002**: **Rejection Reason**: This would increase complexity, dilute expertise, and complicate security and operational standards.

### Azure Plus Other Public Cloud Providers

- **ALT-003**: **Description**: Standardize on Azure for most workloads while allowing limited use of AWS or GCP for specialized cases.
- **ALT-004**: **Rejection Reason**: The organization needs a single approved public cloud boundary to avoid fragmentation and unnecessary exceptions.

### Local Datacenters Only

- **ALT-005**: **Description**: Avoid public cloud entirely and rely only on locally managed datacenters.
- **ALT-006**: **Rejection Reason**: This would reduce agility and fail to meet modern cloud operational expectations for many workloads.

## Implementation Notes

- **IMP-001**: Update internal architecture standards and procurement guidance to reference Azure as the default public cloud.
- **IMP-002**: Review existing workloads and identify any exceptions that should be migrated or explicitly approved.
- **IMP-003**: Maintain clear governance for locally managed datacenters so they are treated as a separate hosting model rather than a backdoor for other clouds.

## References

- **REF-001**: Repository ADR guidance in docs/adr/README.md
- **REF-002**: ADR validation script at .specify/scripts/powershell/validate-adr.ps1
- **REF-003**: Internal cloud governance and platform standards documentation

## Validation Summary

- Required metadata: PASS
- Dependency references: PASS
- Supersession references: PASS
- Circular relationship checks: PASS
- Final status: PASS
