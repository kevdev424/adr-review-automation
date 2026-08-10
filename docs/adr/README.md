# ADRs

This directory stores Architectural Decision Records for the repository.

## Naming convention

New ADR files should use the pattern `adr-NNNN-[title-slug].md` where `NNNN` is a four-digit sequence.

## Relationship metadata

When an ADR depends on or supersedes another ADR, record the relationship in the ADR front matter using the following fields:

- `dependencies`: a list of ADR identifiers or file names for prior decisions the ADR relies on
- `supersedes`: a list of ADR identifiers or file names for prior decisions the ADR narrows or replaces
- `related_adrs`: a list of additional ADR identifiers or file names for context
- `relationship_rationale`: a short explanation of why the selected relationships were chosen
- `conflict_warnings`: a list of warnings for review when a proposed ADR may conflict with existing decisions

## Pull request review commentary

When a pull request proposes or changes an ADR, the automated review posts a PR comment with only final observations about the ADR (no narration of the review process). If the proposed ADR obviously conflicts with an accepted ADR (`status: Accepted`/`Approved`, not superseded), the comment opens with a `## ⚠️ Conflicts with Accepted ADRs — Do Not Merge` heading, before any other content, explaining why the PR should not be merged until the conflict is resolved. Declaring `supersedes` for the accepted ADR you intend to replace prevents that ADR from being reported as a conflict. This warning is informational — it does not block the automated `adr-review-validation` check, but should be resolved before a human reviewer approves the PR.

## Validation

Use the repository validation script at [.specify/scripts/powershell/validate-adr.ps1](.specify/scripts/powershell/validate-adr.ps1) before submitting an ADR for review.
