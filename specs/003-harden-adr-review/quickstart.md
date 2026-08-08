# Quickstart: Validate Hardened ADR Review Commentary

Prerequisites: repository checked out on this feature branch, `pwsh` available, and (for the full Copilot-driven path) the `copilot` CLI installed and authenticated. The deterministic eligibility checks below do not require the Copilot CLI.

## 1. Add fixtures for the conflict scenario

Under `tests/fixtures/adr/`, ensure fixtures exist for:

- An **active accepted ADR** (`status: "Accepted"`, empty `superseded_by`).
- A **superseded accepted ADR** (`status: "Accepted"`, non-empty `superseded_by`).
- A **proposed ADR that obviously conflicts** with the active accepted ADR (e.g., mandates the opposite of the accepted ADR's decision for the same scope).

## 2. Run the deterministic eligibility check

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .specify/scripts/powershell/review-adr.ps1 -AdrRoot ./tests/fixtures/adr -OutputPath ./tests/output/review-summary.md
```

Expected: the active accepted fixture is treated as eligible baseline material; the superseded fixture is excluded, per [data-model.md](./data-model.md).

## 3. Run the full test harness

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File tests/review-adr-tests.ps1
```

Expected: all assertions pass, including the new eligibility-filtering and fixed-heading-contract assertions described in [contracts/adr-review-commentary-contract.md](./contracts/adr-review-commentary-contract.md).

## 4. Validate the local Copilot-driven commentary path (optional, requires `copilot` CLI)

```bash
./scripts/review-adr.sh
cat artifacts/adr-review-summary.md
```

Expected, when the conflicting-proposed fixture is included in `docs/adr/` (or pointed at via a custom ADR root):

- Output begins with `## ⚠️ Conflicts with Accepted ADRs — Do Not Merge`, naming the active accepted ADR and explaining why the PR should not merge.
- No first-person process narration appears anywhere in the output.
- The standard `## ADR Review Summary` section follows the conflicts section.

Expected, when reviewing an ADR with no conflicts:

- No conflicts heading appears anywhere in the output.

## 5. Validate CI parity

Open a draft PR touching `docs/adr/**` with the conflicting fixture ADR and confirm:

- The `adr-review-validation` check still passes (no schema defects).
- The `adr-review-commentary` check posts a PR comment matching the same structure produced locally in step 4.
