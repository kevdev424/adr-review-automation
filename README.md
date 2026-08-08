# adr-review-automation

A repository for storing and reviewing Architecture Decision Records (ADRs) with a lightweight, repository-native review workflow.

## ADR workflow overview

1. Create a new ADR from a dedicated feature branch based on main.
2. Work on the ADR locally and run the local review command before opening a pull request.
3. Open a pull request so the repository applies blocking validation and informational review checks.
4. Merge only after the blocking validation passes and a human reviewer approves the PR.

## Create a new ADR

- Start from the main branch and create a feature branch for the ADR work.
- Add a new ADR file in [docs/adr](docs/adr) using the template in [docs/adr/adr-0000-template.md](docs/adr/adr-0000-template.md).
- Include the required front matter fields: title, status, date, authors, and tags.
- Keep the ADR content structured with a clear title and supporting sections.

## Review locally before opening a PR

Run the local review entrypoint from the repository root:

```bash
./scripts/review-adr.sh
```

This command runs the same review logic that the pull request workflow uses. It produces:

- a blocking validation summary for objective defects such as missing metadata, missing headings, or broken references
- an informational review summary for advisory concerns such as TODOs or areas that may need refinement

## Pull request process

When the ADR work is ready:

1. Commit the ADR changes on the feature branch.
2. Open a pull request targeting main.
3. Allow the automated checks to run:
   - adr-review-validation for blocking validation
   - adr-review-commentary for informational review output
4. Address any blocking issues before requesting review.
5. Wait for human approval and merge once the required checks pass.

## Repository automation

The repository includes:

- a GitHub Actions workflow for ADR PR review
- a ruleset definition that enforces review and status checks
- a local review script for fast feedback before opening a PR
