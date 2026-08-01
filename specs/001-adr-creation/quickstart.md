# Quickstart: Generate or Update an ADR

## Prerequisites

- Review the existing ADR set in docs/adr/ or the repository’s ADR location.
- Prepare the decision context, chosen approach, alternatives, and stakeholders.

## Steps

1. Invoke the ADR creation skill with the decision title, context, decision, alternatives, and stakeholders.
2. Provide any known dependency or supersession relationships when relevant.
3. Review the generated draft for:
   - dependency metadata
   - supersession metadata when a prior ADR is being narrowed or replaced
   - conflict warnings linked to relevant prior ADRs
4. Save the resulting document using the repository ADR naming convention.
5. Review the final ADR for traceability and governance consistency before sharing it.

## Expected Outcome

A new ADR is created with clear relationship metadata, explicit review warnings when appropriate, and enough context for reviewers to understand how it fits into the broader architecture.
