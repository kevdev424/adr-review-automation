# ADR Review Contract

## Overview

The ADR review workflow exposes a repository-managed review contract for pull requests that modify ADR content.

## Inputs

- pull_request_number: the PR number to review
- head_ref: the source branch name
- repository: the repository identifier
- adr_files: the ADR markdown files changed in the PR
- github_token: token used for GitHub CLI operations

## Outputs

- blocking_validation_result: PASS or FAIL
- informational_review_comment: advisory commentary or a summary of no issues
- workflow_status: success or failure

## Processing Rules

1. The workflow MUST run a blocking validation step before any merge can occur.
2. The workflow MUST run an informational review step separately from validation.
3. The workflow MUST post a PR comment with the informational review results when the review skill produces advisory findings.
4. The workflow MUST fail the PR when the blocking validation step detects objective issues.
