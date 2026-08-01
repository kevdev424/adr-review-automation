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

## Validation

Use the repository validation script at [.specify/scripts/powershell/validate-adr.ps1](.specify/scripts/powershell/validate-adr.ps1) before submitting an ADR for review.
