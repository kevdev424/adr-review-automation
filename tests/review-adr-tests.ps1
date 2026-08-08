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

Write-Host 'Review automation regression checks passed.'
