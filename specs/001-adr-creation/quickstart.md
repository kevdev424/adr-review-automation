# Quickstart: Generate or Update an ADR

## Prerequisites

- Review the existing ADR set in docs/adr/ or the repository’s ADR location.
- Prepare the decision context, chosen approach, alternatives, and stakeholders.
- If prior ADRs are known, gather their identifiers or filenames so the new ADR can reference them correctly.

## Steps

1. Invoke the ADR creation skill with the decision title, context, decision, alternatives, and stakeholders.
2. Provide any known dependency, supersession, or related ADR references when relevant.
3. Review the generated draft for:
   - dependency metadata in the front matter
   - supersession metadata when a prior ADR is being narrowed or replaced
   - conflict warnings linked to relevant prior ADRs
   - a validation summary showing PASS, WARN, or FAIL values for metadata and relationship checks
4. If no prior ADRs are discovered, note that in the draft and proceed with a zero-dependency relationship chain.
5. Save the resulting document using the repository ADR naming convention.
6. Review the final ADR for traceability and governance consistency before sharing it.

## Expected Outcome

A new ADR is created with clear relationship metadata, explicit review warnings when appropriate, and a validation summary that helps reviewers assess whether the draft is ready for approval.
