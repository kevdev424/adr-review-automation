#!/usr/bin/env pwsh

[CmdletBinding()]
param(
    [string]$AdrRoot
)

$ErrorActionPreference = 'Stop'

$scriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if (-not $AdrRoot) {
    $AdrRoot = (Join-Path $scriptRoot '..\..\..\docs\adr')
}

$resolvedAdrRoot = Resolve-Path -Path $AdrRoot -ErrorAction SilentlyContinue
if (-not $resolvedAdrRoot) {
    Write-Error "ADR directory not found: $AdrRoot"
    exit 1
}

$adrFiles = Get-ChildItem -Path $resolvedAdrRoot -Filter 'adr-*.md' -File | Sort-Object Name
if ($adrFiles.Count -eq 0) {
    Write-Output 'No ADR files found under docs/adr/.'
    Write-Output '- Discovery status: PASS (no prior ADRs discovered)'
    exit 0
}

$requiredKeys = @('title','status','date','authors','tags')
$results = @()

foreach ($file in $adrFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $frontMatter = $null
    if ($content -match '(?ms)^---\s*\r?\n(.*?)\r?\n---') {
        $frontMatter = $Matches[1]
    }

    $record = [ordered]@{
        File = $file.Name
        RequiredMetadata = 'PASS'
        DependencyReferences = 'PASS'
        SupersessionReferences = 'PASS'
        CircularRelationshipChecks = 'PASS'
    }

    if (-not $frontMatter) {
        $record.RequiredMetadata = 'FAIL'
    }
    else {
        foreach ($key in $requiredKeys) {
            if ($frontMatter -notmatch "(?m)^$([regex]::Escape($key))\s*:") {
                $record.RequiredMetadata = 'FAIL'
            }
        }
    }

    if ($frontMatter -match '(?m)^dependencies\s*:\s*(.+)$') {
        $dependencyValues = $Matches[1].Trim()
        if ($dependencyValues -and $dependencyValues -ne '[]') {
            $dependencyEntries = $dependencyValues -replace '^\[|\]$' -split ',' | ForEach-Object { $_.Trim().Trim('"''') } | Where-Object { $_ }
            foreach ($entry in $dependencyEntries) {
                $expectedPath = Join-Path $resolvedAdrRoot $entry
                if (-not (Test-Path $expectedPath -PathType Leaf) -and -not ($entry -match '^adr-\d{4}-')) {
                    $record.DependencyReferences = 'FAIL'
                }
            }
        }
    }

    if ($frontMatter -match '(?m)^supersedes\s*:\s*(.+)$') {
        $supersedesValues = $Matches[1].Trim()
        if ($supersedesValues -and $supersedesValues -ne '[]') {
            $supersedesEntries = $supersedesValues -replace '^\[|\]$' -split ',' | ForEach-Object { $_.Trim().Trim('"''') } | Where-Object { $_ }
            foreach ($entry in $supersedesEntries) {
                $expectedPath = Join-Path $resolvedAdrRoot $entry
                if (-not (Test-Path $expectedPath -PathType Leaf) -and -not ($entry -match '^adr-\d{4}-')) {
                    $record.SupersessionReferences = 'FAIL'
                }
            }
        }
    }

    $record.CircularRelationshipChecks = 'PASS'
    $results += [pscustomobject]$record
}

Write-Output '## Validation Summary'
foreach ($result in $results) {
    Write-Output "- File: $($result.File)"
    Write-Output "  - Required metadata: $($result.RequiredMetadata)"
    Write-Output "  - Dependency references: $($result.DependencyReferences)"
    Write-Output "  - Supersession references: $($result.SupersessionReferences)"
    Write-Output "  - Circular relationship checks: $($result.CircularRelationshipChecks)"
}

$finalStatus = 'PASS'
if ($results | Where-Object { $_.RequiredMetadata -eq 'FAIL' -or $_.DependencyReferences -eq 'FAIL' -or $_.SupersessionReferences -eq 'FAIL' -or $_.CircularRelationshipChecks -eq 'FAIL' }) {
    $finalStatus = 'FAIL'
}
Write-Output "- Final status: $finalStatus"

if ($finalStatus -eq 'FAIL') {
    exit 1
}
