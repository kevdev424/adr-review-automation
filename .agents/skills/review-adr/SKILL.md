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
- The output MUST contain only final observations and conclusions about the ADR's content, structure, and quality — never narrate the review process itself.
- Narration is any sentence describing your own steps or actions using first-person action language (e.g., "I checked...", "I looked...", "I considered...", "I will now..."). Do not emit sentences like this. A sentence that states an observation about the ADR itself (e.g., "The ADR is missing a Consequences section.") is not narration and is required.
- When no issues are found, state in no more than two sentences that the ADR looks acceptable. Do not elaborate further.

## Execution guidance

- Review the ADR files in the change set.
- Validate required front matter and structure.
- Highlight subjective improvements separately from blocking defects.
- Keep the output concise and actionable.
- Before finalizing your response, remove any sentence that narrates your own analysis process rather than stating a conclusion about the ADR.

## Conflicts with accepted ADRs

- An "eligible accepted ADR" is any ADR whose `status` front matter field is `Accepted` or `Approved` (case-insensitive) AND whose `superseded_by` field is empty. Accepted ADRs that have a non-empty `superseded_by` are not eligible and must never be cited as a conflict target.
- Compare each proposed ADR against every eligible accepted ADR. If the proposed ADR obviously and directly contradicts an eligible accepted ADR's decision for the same scope (not a subtle or speculative overlap), that is a Conflict Finding.
- If the proposed ADR's `supersedes` field names an eligible accepted ADR, do NOT report that ADR as a conflict — the supersession is intentional. If `supersedes` names an ADR that does not exist or is not an eligible accepted ADR, treat that entry as if no supersession was declared and still evaluate the named ADR (if otherwise eligible) for conflicts normally.
- If one or more Conflict Findings exist, your output MUST begin with this exact heading, before any other content, with no text before it:

  ```
  ## ⚠️ Conflicts with Accepted ADRs — Do Not Merge
  ```

  Follow the heading with one bullet per Conflict Finding, each naming the specific eligible accepted ADR and explaining, in plain language, the nature of the contradiction and why the pull request should not be merged until it is addressed.
- If there are no Conflict Findings, do NOT emit this heading or section at all — proceed directly to the standard `## ADR Review Summary` output. Never emit an empty or "no conflicts" variant of this section.
- This heading text is exact and locked (case- and punctuation-exact) and applies to GitHub-flavored Markdown PR comments only.
