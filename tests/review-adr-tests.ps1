#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repoRoot '.specify/scripts/powershell/validate-adr.ps1'
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

Write-Host 'Review automation regression checks passed.'
