# Data Model: ADR Review Process

## ADRReviewPolicy
Represents the repository-managed ruleset that governs merge eligibility for ADR pull requests.

**Fields**:
- name: human-readable ruleset name
- target: repository or branch scope for the ruleset
- required_status_checks: the workflow checks that must pass
- required_reviews: count and scope of human approvals required
- bypass_actors: actors allowed to bypass rules where applicable
- enforcement: active or dry-run mode

## ADRReviewRun
Represents the execution of the automated review workflow for a specific pull request.

**Fields**:
- pull_request_number: the PR identifier
- head_branch: the branch containing the ADR draft
- blocking_validation_status: PASS or FAIL
- informational_review_status: PASS, WARN, or FAIL
- review_comment_url: URL or reference to the posted review comment
- workflow_run_id: the CI run identifier

## ADRReviewFinding
Represents a single finding from either the validation or informational review step.

**Fields**:
- severity: blocking or informational
- category: schema, missing-information, incompleteness, conflict, or other
- message: the human-readable explanation
- evidence: optional reference to a file or section

## ADRReviewSkill
Represents the local or CI-executable review skill that evaluates an ADR and produces findings.

**Fields**:
- name: the skill identifier
- input: the ADR content or changed files to review
- output: blocking and informational findings
- execution_mode: local or CI
