# Implementation Plan: ADR Review Process

**Branch**: `002-adr-review-process` | **Date**: 2026-08-01 | **Spec**: [specs/002-adr-review-process/spec.md](specs/002-adr-review-process/spec.md)

**Input**: Feature specification from [specs/002-adr-review-process/spec.md](specs/002-adr-review-process/spec.md)

## Summary

Implement a pull-request-based ADR review workflow that uses GitHub rulesets for merge enforcement, GitHub Actions for automation, and the Copilot CLI to run a review skill that produces both blocking validation feedback and informational advisory comments. The implementation will also support local execution of the review skill so contributors can see the feedback before opening a PR.

## Technical Context

**Language/Version**: PowerShell, YAML, JSON, Markdown, and GitHub Actions workflows.

**Primary Dependencies**: GitHub Actions, GitHub Rulesets, GitHub CLI, Copilot CLI, the existing ADR validation PowerShell script, and the repository-local ADR creation skill conventions.

**Storage**: Repository files under .github/workflows/, .github/rulesets/, .specify/scripts/powershell/, and docs/adr/ for ADR content.

**Testing**: Repository-local validation scripts, GitHub Actions workflow execution, and manual local runs of the review skill against sample ADR content. The implementation will use the workflow check names `adr-review-validation` and `adr-review-commentary` so the merge gate and CI output are explicit, and the same skill will be used for local execution and PR execution.

**Target Platform**: GitHub repository workflows used from both CI and local developer environments.

**Project Type**: Documentation automation / repository governance automation.

**Performance Goals**: The review workflow should complete quickly for a single ADR PR and remain lightweight enough to run as part of normal pull request checks.

**Constraints**: The implementation must use repository-managed configuration where possible, must not require a custom runtime service, and must assume a GitHub PAT token is available via a repository secret for CLI-based GitHub interactions.

**Scale/Scope**: The initial release covers ADR review in this repository and its existing governance model.

## Constitution Check

GATE: Must pass before implementation proceeds.

- Pass: The plan preserves the ADR-first governance model from the constitution by making ADR review a required part of the pull request path.
- Pass: The plan keeps review and merge control on non-main branches through pull requests and GitHub rulesets, consistent with the constitution.
- Pass: The plan supports repository validation and human approval before merge, which aligns with the quality gates and approval requirements.
- Pass: The plan keeps the workflow repository-native and versioned so that governance changes remain traceable and reviewable.

## Project Structure

### Documentation (this feature)

```text
specs/002-adr-review-process/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
```

### Source Code (repository root)

```text
.github/
├── workflows/
│   ├── adr-validation.yml
│   ├── adr-review.yml
│   └── deploy-ruleset.yml
├── rulesets/
│   └── adr-review-ruleset.json
└── prompts/
    └── review-adr.prompt.md

.specify/
├── scripts/
│   └── powershell/
│       ├── validate-adr.ps1
│       └── review-adr.ps1

.agents/
└── skills/
    └── review-adr/
        └── SKILL.md

scripts/
└── review-adr.sh
```

**Structure Decision**: Implement the feature as repository-local automation and governance configuration. The core review logic will be delivered as PowerShell scripts and workflow files, with a Copilot CLI-compatible review skill and a ruleset definition stored in the repository for deployment from CI or local tooling. The workflow will expose `adr-review-validation` for blocking defects and `adr-review-commentary` for advisory feedback so the ruleset and PR checks map directly to the implementation.

## Complexity Tracking

No constitution violations are expected for this change.
