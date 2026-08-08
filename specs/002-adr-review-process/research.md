# Research: ADR Review Process

## Decision 1: Use GitHub rulesets for merge enforcement

**Decision**: Store a repository ruleset definition as JSON in the repo and deploy it from a dedicated workflow triggered on merges to main.

**Rationale**: The requirement explicitly calls for ruleset-based enforcement and versioned repository configuration so the policy can be updated intentionally and reviewed like code.

**Alternatives considered**:
- Rely only on branch protection settings in the UI.
- Encode the policy in workflow logic only without repository-managed ruleset definitions.

## Decision 2: Separate blocking validation from informational advisory review

**Decision**: The automated workflow will run two distinct steps: a blocking validation step for objective defects and an informational review step for advisory comments about possible conflicts or subjectivity.

**Rationale**: This matches the clarified requirement that objective mistakes must block merge while review opinions remain informational only.

**Alternatives considered**:
- Use a single review step for both blocking and informational issues.
- Make subjective feedback block merge.

## Decision 3: Use GitHub Actions for automation and Copilot CLI for review execution

**Decision**: GitHub Actions will run the ADR validation and PR review workflow, and the Copilot CLI will be invoked from the workflow and from a local script to execute the review skill.

**Rationale**: This keeps the automation close to the repository and allows the same review logic to run in CI and locally.

**Alternatives considered**:
- Create a standalone server or external service for review execution.
- Use only local scripts without CI integration.

## Decision 4: Support local review execution with a PAT-based CLI path

**Decision**: The local review script will accept a GitHub token from an environment variable and use the GitHub CLI to read PR context, while the Copilot CLI executes the review skill locally.

**Rationale**: The requirement assumes a PAT token will be provided as a GitHub secret for CLI interactions, and the same pattern can be mirrored locally for contributors.

**Alternatives considered**:
- Require only GitHub Actions for review execution.
- Hard-require a remote service for PR comment creation.

## Decision 5: Keep the implementation repository-native

**Decision**: Store workflow YAML, ruleset JSON, PowerShell automation, and the review skill definition in the repository rather than introducing another service or external database.

**Rationale**: This keeps the solution understandable, reviewable, and easy to evolve with the repo’s governance model.

**Alternatives considered**:
- Store policy in a separate portal or external SaaS system.
- Keep automation as ad hoc scripts outside the repository.
