# Research: ADR Dependency-Aware Creation

## Decision 1: Extend the existing skill rather than introduce a separate workflow

**Decision**: Update the existing skill in [.agents/skills/create-architectural-decision-record/SKILL.md](.agents/skills/create-architectural-decision-record/SKILL.md) so it can generate ADRs that are aware of prior decisions.

**Rationale**: The repository already has a dedicated ADR creation skill, and the feature request is a natural extension of that workflow rather than a new product area.

**Alternatives considered**:
- Add a separate prompt or workflow file instead of changing the skill.
- Create a standalone tool or service for ADR generation.

## Decision 2: Use explicit metadata for relationship types

**Decision**: Capture relationships in structured metadata fields such as dependencies, supersedes, related_adrs, and relationship_rationale.

**Rationale**: This supports both human readability and future automation without relying on free-form prose alone.

**Alternatives considered**:
- Keep all relationships in plain text only.
- Use a single generic field for all related ADRs.

## Decision 3: Treat conflicts as warnings for human review

**Decision**: When a proposed ADR appears to conflict with an existing ADR, the workflow should emit a warning and require explicit review rather than block the draft automatically.

**Rationale**: This choice was clarified as the preferred governance behavior and avoids over-constraining authors while still preventing silent contradictions.

**Alternatives considered**:
- Hard-block the draft until the conflict is resolved.
- Allow contradictions without any warning.

## Decision 4: Keep the output format compatible with the current ADR template

**Decision**: Preserve the current ADR document structure while extending it with relationship metadata and review guidance sections.

**Rationale**: The existing ADR template already aligns with repository conventions and should be extended rather than replaced.

**Alternatives considered**:
- Introduce an entirely new ADR format.
- Store relationship data outside the ADR document.
