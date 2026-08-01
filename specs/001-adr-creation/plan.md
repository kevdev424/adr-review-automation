# Implementation Plan: ADR Dependency-Aware Creation

**Branch**: `001-adr-creation` | **Date**: 2026-08-01 | **Spec**: [specs/001-adr-creation/spec.md](specs/001-adr-creation/spec.md)

**Input**: Feature specification from [specs/001-adr-creation/spec.md](specs/001-adr-creation/spec.md)

## Summary

Extend the existing ADR creation skill so it can draft new ADRs in a dependency-aware way. The implementation will preserve a clear decision chain, support both dependency and supersession relationships, and surface likely conflicts as review warnings that help keep the architecture coherent.

## Technical Context

**Language/Version**: Markdown, YAML, and JSON metadata; no runtime service is required.

**Primary Dependencies**: GitHub Copilot skill format, repository conventions from the existing Speckit workflow, and the current ADR documentation structure.

**Storage**: Repository markdown files, with new ADR documents stored under docs/adr/ and supporting metadata captured in the skill and ADR front matter.

**ADR Discovery**: Existing ADRs will be discovered from files under docs/adr/ matching the naming convention adr-NNNN-[title-slug].md, and the workflow will report clearly when no prior ADRs are found.

**Validation**: The workflow must support repository validation for required front matter, dependency and supersession references, and circular relationship checks before an ADR is considered ready for review. The implementation will include an automated repository validation step that checks ADR schema, required fields, dependency references, supersession references, and circular-relationship integrity, and it will emit a markdown validation summary section in each ADR draft using a fixed template with PASS, WARN, or FAIL values.

**Testing**: Manual validation of generated ADR content and repository review checks; future automation can be added under GitHub Actions if the repository expands its validation workflow.

**Target Platform**: GitHub repository workflow used from VS Code and Copilot skill execution.

**Project Type**: Documentation automation / skill workflow.

**Performance Goals**: Not applicable; the workflow is document-creation focused and should remain lightweight.

**Constraints**: The implementation must remain compatible with the existing skill format and should not introduce a separate service or runtime dependency.

**Scale/Scope**: Limited to ADR authoring in this repository and its existing governance model.

## Constitution Check

GATE: Must pass before implementation proceeds.

- Pass: The plan preserves the ADR-first governance model from the constitution.
- Pass: The plan explicitly records dependency and supersession relationships, which supports consistency and traceability.
- Pass: The plan keeps conflicts as review warnings rather than silent acceptance, aligning with the repository’s quality gates.
- Pass: The plan includes repository-level validation of required fields, dependency references, supersession references, and circular relationship checks before review approval, and it requires a consistent validation summary section in the draft.
- Pass: The plan defines an explicit automated validation implementation step for ADR schema and relationship integrity checks.
- Pass: The plan keeps the workflow reviewable and repository-native rather than introducing ungoverned automation.

## Project Structure

### Documentation (this feature)

```text
specs/001-adr-creation/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
```

### Source Code (repository root)

```text
.agents/
└── skills/
    └── create-architectural-decision-record/
        └── SKILL.md

docs/
└── adr/
```

**Structure Decision**: Implement the feature as an update to the existing repository-local skill plus supporting ADR documentation templates and contract guidance. No separate application service is required.

## Complexity Tracking

No constitution violations are expected for this change.
