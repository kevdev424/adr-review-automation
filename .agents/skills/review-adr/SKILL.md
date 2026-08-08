---
name: review-adr
description: Review ADR content for blocking validation issues and informational advisory concerns.
---

# Review ADR Skill

Use this skill to review ADR changes before merge. It should produce:

- a blocking validation result for objective defects
- an informational review result for advisory feedback

## Expected outputs

- If objective defects are found, emit a blocking failure summary.
- If only advisory concerns are found, emit a non-blocking advisory summary.

## Execution guidance

- Review the ADR files in the change set.
- Validate required front matter and structure.
- Highlight subjective improvements separately from blocking defects.
- Keep the output concise and actionable.
