# Quickstart: ADR Review Workflow

## Prerequisites

- A GitHub repository with Actions enabled
- A GitHub token available through a repository secret named GITHUB_TOKEN or a PAT secret for CLI interactions
- The GitHub CLI installed locally
- The Copilot CLI installed locally

## Steps

1. Store the ruleset JSON definition in the repository under .github/rulesets/.
2. Add a workflow that deploys the ruleset on merges to main.
3. Add a pull request workflow that runs the ADR validation and review skill for ADR changes.
4. Run the local review command `./scripts/review-adr.sh` against a pull request branch or a local ADR change set. The command MUST invoke the same review skill used in the PR workflow and MUST emit a blocking summary for objective defects and a separate informational summary for advisory observations.
5. Review the blocking and informational outputs before approving the PR.

## Expected Outcome

A pull request for a new ADR will trigger the review workflow, receive a blocking validation result when objective errors exist, and receive a separate informational review comment for advisory concerns. Merge remains blocked until the blocking checks pass and a human reviewer approves the PR.
