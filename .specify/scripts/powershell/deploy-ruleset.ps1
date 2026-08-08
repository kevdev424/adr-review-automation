#!/usr/bin/env pwsh

[CmdletBinding()]
param(
    [string]$RulesetPath,
    [string]$Repository = $env:GITHUB_REPOSITORY,
    [string]$GitHubToken = $env:GITHUB_TOKEN,
    [string]$BaseBranch = 'main'
)

$ErrorActionPreference = 'Stop'

if (-not $RulesetPath) {
    $RulesetPath = Join-Path $PSScriptRoot '..\..\..\.github\rulesets\adr-review-ruleset.json'
}

if (-not (Test-Path $RulesetPath)) {
    Write-Error "Ruleset file not found: $RulesetPath"
    exit 1
}

if (-not $GitHubToken) {
    Write-Output 'GitHub token not provided; skipping remote ruleset deployment.'
    exit 0
}

$rulesetContent = Get-Content -Path $RulesetPath -Raw
$payload = $rulesetContent | ConvertFrom-Json

$headers = @{ Authorization = "Bearer $GitHubToken" }
$uri = "https://api.github.com/repos/$Repository/rulesets"

try {
    $response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -ContentType 'application/json' -Body ($payload | ConvertTo-Json -Depth 20)
    Write-Output "Ruleset deployed to $Repository"
    if ($response.id) {
        Write-Output "Ruleset id: $($response.id)"
    }
} catch {
    Write-Error "Ruleset deployment failed: $($_.Exception.Message)"
    exit 1
}
