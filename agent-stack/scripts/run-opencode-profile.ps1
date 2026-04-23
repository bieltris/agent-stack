param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ProfileName,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$OpenCodeArgs
)

$ErrorActionPreference = "Stop"

$stackRoot = Split-Path -Parent $PSScriptRoot
$profilesPath = Join-Path $stackRoot "profiles.json"
$profiles = Get-Content $profilesPath -Raw | ConvertFrom-Json

if (-not ($profiles.PSObject.Properties.Name -contains $ProfileName)) {
    Write-Host "Perfil invalido: $ProfileName" -ForegroundColor Red
    Write-Host "Perfis disponiveis: $($profiles.PSObject.Properties.Name -join ', ')" -ForegroundColor Yellow
    exit 1
}

$profile = $profiles.$ProfileName
$env:OPENCODE_CONFIG = Join-Path $stackRoot $profile.config

if ($profile.provider -eq "nvidia" -and -not $env:NVIDIA_API_KEY) {
    $savedKey = [System.Environment]::GetEnvironmentVariable("NVIDIA_API_KEY", "User")
    if ($savedKey) {
        $env:NVIDIA_API_KEY = $savedKey
    }
}

if ($profile.provider -eq "nvidia" -and -not $env:NVIDIA_API_KEY) {
    Write-Host "NVIDIA_API_KEY nao esta definido. Veja docs/01-secrets-and-auth.md" -ForegroundColor Yellow
    exit 1
}

if ($profile.provider -eq "ollama-local") {
    $env:OLLAMA_API_BASE = if ($env:OLLAMA_API_BASE) { $env:OLLAMA_API_BASE } else { "http://127.0.0.1:11434" }
    $env:OLLAMA_OPENCODE_BASE = if ($env:OLLAMA_OPENCODE_BASE) { $env:OLLAMA_OPENCODE_BASE } else { "http://127.0.0.1:11434/v1" }
}

Write-Host "OpenCode profile: $ProfileName -> $($profile.model)" -ForegroundColor Cyan
opencode --model $profile.model @OpenCodeArgs
