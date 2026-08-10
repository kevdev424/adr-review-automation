#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repoRoot '.specify/scripts/powershell/validate-adr.ps1'
$reviewer = Join-Path $repoRoot '.specify/scripts/powershell/review-adr.ps1'
$validFixture = Join-Path $repoRoot 'tests/fixtures/adr/adr-0001-valid.md'
$invalidFixture = Join-Path $repoRoot 'tests/fixtures/adr/adr-0002-invalid.md'

$psCommand = $null
if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    $psCommand = 'pwsh'
} elseif (Get-Command powershell -ErrorAction SilentlyContinue) {
    $psCommand = 'powershell'
} else {
    throw 'Neither pwsh nor powershell is available in this environment.'
}

if (-not (Test-Path $validator)) {
    throw "Validator script not found: $validator"
}
if (-not (Test-Path $reviewer)) {
    throw "Review script not found: $reviewer"
}

$tmpRoot = Join-Path $repoRoot 'tests/output'
New-Item -ItemType Directory -Path $tmpRoot -Force | Out-Null

$validDir = Join-Path $tmpRoot 'valid-fixture'
$invalidDir = Join-Path $tmpRoot 'invalid-fixture'
New-Item -ItemType Directory -Path $validDir -Force | Out-Null
New-Item -ItemType Directory -Path $invalidDir -Force | Out-Null
Copy-Item $validFixture (Join-Path $validDir 'adr-0001-valid.md') -Force
Copy-Item $invalidFixture (Join-Path $invalidDir 'adr-0002-invalid.md') -Force

& $psCommand -NoProfile -ExecutionPolicy Bypass -File $validator -AdrRoot $validDir
if ($LASTEXITCODE -ne 0) {
    throw 'Expected the valid ADR fixture to pass validation.'
}

& $psCommand -NoProfile -ExecutionPolicy Bypass -File $validator -AdrRoot $invalidDir
if ($LASTEXITCODE -eq 0) {
    throw 'Expected the invalid ADR fixture to fail validation.'
}

$reviewOutput = Join-Path $tmpRoot 'review-summary.md'
$reviewResult = & $psCommand -NoProfile -ExecutionPolicy Bypass -File $reviewer -AdrRoot $invalidDir -OutputPath $reviewOutput 2>&1
if ($LASTEXITCODE -eq 0) {
    throw 'Expected the invalid ADR fixture to fail review.'
}

$reviewText = ($reviewResult | Out-String)
if ($reviewText -notmatch 'authors metadata is missing') {
    throw 'Expected the review summary to report missing authors metadata.'
}
if ($reviewText -notmatch 'tags metadata is missing') {
    throw 'Expected the review summary to report missing tags metadata.'
}
if (-not (Test-Path $reviewOutput)) {
    throw 'Expected the review summary file to be created.'
}

# --- FR-002/FR-011: no first-person action-language narration in the deterministic ---
# --- reviewer's own output, and a short no-issues statement (regression guard). ---
$firstPersonActionPattern = '(?i)\bI\s+(checked|looked|considered|will now|examined|reviewed|analyzed)\b'
if ($reviewText -match $firstPersonActionPattern) {
    throw 'Review summary output must not contain first-person action-language narration.'
}

$cleanDir = Join-Path $tmpRoot 'clean-fixture'
New-Item -ItemType Directory -Path $cleanDir -Force | Out-Null
Copy-Item (Join-Path $repoRoot 'tests/fixtures/adr/adr-0006-clean-proposed.md') (Join-Path $cleanDir 'adr-0006-clean-proposed.md') -Force
$cleanReviewText = (& $psCommand -NoProfile -ExecutionPolicy Bypass -File $reviewer -AdrRoot $cleanDir | Out-String)
if ($cleanReviewText -match $firstPersonActionPattern) {
    throw 'Clean-fixture review summary must not contain first-person action-language narration.'
}
if ($cleanReviewText -notmatch 'No advisory concerns detected\.') {
    throw 'Expected a short no-issues statement for the clean fixture.'
}

# --- FR-003/FR-003a/FR-007a: accepted-baseline eligibility computation (US2) ---
$conflictDir = Join-Path $tmpRoot 'conflict-fixtures'
New-Item -ItemType Directory -Path $conflictDir -Force | Out-Null
foreach ($fixtureName in @(
    'adr-0003-accepted-baseline.md',
    'adr-0004-superseded-baseline.md',
    'adr-0005-conflicting-proposed.md',
    'adr-0006-clean-proposed.md',
    'adr-0007-superseding-proposed.md'
)) {
    Copy-Item (Join-Path $repoRoot "tests/fixtures/adr/$fixtureName") (Join-Path $conflictDir $fixtureName) -Force
}

$eligibilityText = (& $psCommand -NoProfile -ExecutionPolicy Bypass -File $reviewer -AdrRoot $conflictDir | Out-String)
if ($eligibilityText -notmatch 'adr-0003-accepted-baseline\.md: Eligible') {
    throw 'Expected the active accepted fixture (adr-0003) to be treated as eligible baseline.'
}
if ($eligibilityText -notmatch 'adr-0004-superseded-baseline\.md: Not eligible \(superseded\)') {
    throw 'Expected the superseded fixture (adr-0004) to be excluded from the eligible baseline.'
}
if ($eligibilityText -notmatch 'adr-0005-conflicting-proposed\.md: Not eligible \(not accepted\)') {
    throw 'Expected the proposed conflicting fixture (adr-0005) to be excluded from the eligible baseline.'
}
if ($eligibilityText -notmatch 'adr-0007-superseding-proposed\.md: Not eligible \(not accepted\)') {
    throw 'Expected the proposed superseding fixture (adr-0007) to be excluded from the eligible baseline (it is a proposal, not itself accepted).'
}

# --- FR-004/FR-006: conflicts-first fixed heading is defined in the shared prompt contract ---
# (the actual conflict judgment is LLM-driven; this regression check asserts the contract
# text both consumers rely on contains the exact, locked heading and ordering instruction.)
$skillPath = Join-Path $repoRoot '.agents/skills/review-adr/SKILL.md'
$promptPath = Join-Path $repoRoot '.github/prompts/review-adr.prompt.md'
$expectedHeading = '## ⚠️ Conflicts with Accepted ADRs — Do Not Merge'
foreach ($contractFile in @($skillPath, $promptPath)) {
    $contractText = Get-Content -Path $contractFile -Raw
    if ($contractText -notmatch [regex]::Escape($expectedHeading)) {
        throw "Expected $contractFile to contain the exact locked conflicts heading."
    }
    if ($contractText -notmatch '(?i)supersedes') {
        throw "Expected $contractFile to document declared-supersession exclusion (FR-007/FR-007a)."
    }
}

# --- FR-008/US3: blocking validation stays PASS even when a conflict-fixture pair is present ---
$blockingIndependenceDir = Join-Path $tmpRoot 'blocking-independence'
New-Item -ItemType Directory -Path $blockingIndependenceDir -Force | Out-Null
Copy-Item (Join-Path $repoRoot 'tests/fixtures/adr/adr-0003-accepted-baseline.md') (Join-Path $blockingIndependenceDir 'adr-0003-accepted-baseline.md') -Force
Copy-Item (Join-Path $repoRoot 'tests/fixtures/adr/adr-0005-conflicting-proposed.md') (Join-Path $blockingIndependenceDir 'adr-0005-conflicting-proposed.md') -Force
& $psCommand -NoProfile -ExecutionPolicy Bypass -File $validator -AdrRoot $blockingIndependenceDir
if ($LASTEXITCODE -ne 0) {
    throw 'Expected blocking validation to PASS for the conflicting-but-schema-valid fixture pair (FR-008).'
}

Write-Host 'Review automation regression checks passed.'
