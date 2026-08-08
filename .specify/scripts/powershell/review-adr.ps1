#!/usr/bin/env pwsh

[CmdletBinding()]
param(
    [string]$AdrRoot,
    [string]$OutputPath,
    [string]$Repository = $env:GITHUB_REPOSITORY,
    [string]$PrNumber = $env:PR_NUMBER,
    [string]$GitHubToken = $env:GITHUB_TOKEN
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
$blockingMessages = New-Object System.Collections.Generic.List[string]
$advisoryMessages = New-Object System.Collections.Generic.List[string]

foreach ($file in $adrFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    if ($content -notmatch '(?ms)^---\s*\r?\n(.*?)\r?\n---') {
        $blockingMessages.Add("$($file.Name): missing YAML front matter")
        continue
    }

    $frontMatter = $Matches[1]
    if ($frontMatter -notmatch '(?m)^title\s*:') {
        $blockingMessages.Add("$($file.Name): title metadata is missing")
    }
    if ($frontMatter -notmatch '(?m)^status\s*:') {
        $blockingMessages.Add("$($file.Name): status metadata is missing")
    }
    if ($frontMatter -notmatch '(?m)^date\s*:') {
        $blockingMessages.Add("$($file.Name): date metadata is missing")
    }
    if ($frontMatter -notmatch '(?m)^authors\s*:') {
        $blockingMessages.Add("$($file.Name): authors metadata is missing")
    }
    if ($content -notmatch '(?m)^# ') {
        $blockingMessages.Add("$($file.Name): missing H1 heading")
    }

    if ($content -match '(?i)\bTODO\b') {
        $advisoryMessages.Add("$($file.Name): contains TODO language that may need refinement")
    }
}

if ($blockingMessages.Count -eq 0) {
    $blockingSummary = 'PASS'
} else {
    $blockingSummary = 'FAIL'
}

$reviewSummary = @()
$reviewSummary += '## ADR Review Summary'
$reviewSummary += ''
$reviewSummary += "- Blocking validation: $blockingSummary"
if ($blockingMessages.Count -gt 0) {
    $reviewSummary += '- Blocking findings:'
    foreach ($message in $blockingMessages) {
        $reviewSummary += "  - $message"
    }
} else {
    $reviewSummary += '- Blocking findings: none'
}

$reviewSummary += '- Informational review:'
if ($advisoryMessages.Count -gt 0) {
    foreach ($message in $advisoryMessages) {
        $reviewSummary += "  - $message"
    }
} else {
    $reviewSummary += '  - No advisory concerns detected.'
}

$summaryText = $reviewSummary -join [Environment]::NewLine
if ($OutputPath) {
    $parentPath = Split-Path -Parent $OutputPath
    if ($parentPath) {
        New-Item -ItemType Directory -Path $parentPath -Force | Out-Null
    }
    Set-Content -Path $OutputPath -Value $summaryText -Encoding UTF8
}

Write-Output $summaryText

if ($blockingMessages.Count -gt 0) {
    exit 1
}
