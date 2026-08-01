<!-- Sync Impact Report
- Version change: 1.0.0 -> 1.1.0
- Modified principles: none
- Added sections: none
- Removed sections: none
- Follow-up TODOs: none
-->

# ADR Review Automation Constitution

## Core Principles

### I. ADR-First Implementation
Every implementation proposal, feature change, or system evolution must be grounded in a corresponding ADR or ADR amendment. If a decision affects architecture, implementation patterns, or interoperability, the ADR must be created or updated before implementation work proceeds.

### II. Consistency and Non-Contradiction
ADRs must not contradict one another. When a new ADR supersedes, narrows, or extends an earlier decision, the relationship must be explicitly recorded in the ADR metadata and the dependency chain must remain traceable.

### III. Dependency Traceability
Each ADR must declare its dependencies, derived decisions, and supersession relationships. The repository must maintain a clear dependency chain so that downstream implementations can understand which ADRs are foundational and which are derived.

### IV. Review by Approval
Formal ADRs in the main branch are the source of truth. Proposed changes to formal ADRs must be submitted through pull requests from non-main branches, must pass automated checks, and must receive human approval before merge.

### V. Schema and Quality Gates
All ADRs must conform to the required schema and pass repository tests before they are accepted. Automation must validate structure, required fields, dependency references, and relationship integrity.

## ADR Content Standards
Each ADR must include a clear title, status, context, decision, consequences, and explicit relationship metadata such as dependencies, supersedes, or derived-from references. ADRs must be written in a way that supports reuse across multiple applications and must avoid implementation details that are not necessary to express the architectural decision.

## ADR Review and Delivery Workflow
The repository must use GitHub Actions to run automated validation for ADR proposals. Pull requests that add or modify ADRs must be evaluated for schema compliance, relationship consistency, and test coverage before they can be merged. The main branch remains the authoritative location for finalized ADRs, and AI-assisted workflows using skills, prompts, plugins, and automation must preserve this governance model. For every new specification effort, a feature branch must be created from main before any work begins, and that branch must be checked out and used to hold all related changes until the work is reviewed and merged. Direct work on main is prohibited for new spec creation.

## Governance
This constitution governs how ADRs are created, reviewed, approved, and implemented in this repository. It supersedes ad hoc decision-making and any workflow that would allow conflicting or untracked architectural decisions to enter the main branch.

Amendments to this constitution must be proposed through a pull request, reviewed for impact on ADR governance, and approved by a human reviewer before merge. Versioning follows semantic versioning: major changes remove or redefine governing principles, minor changes add or materially expand guidance, and patches make clarifications or non-semantic refinements. Compliance with this constitution is reviewed whenever ADR workflow changes are proposed or when repository automation is updated.

**Version**: 1.1.0 | **Ratified**: 2026-08-01 | **Last Amended**: 2026-08-01
