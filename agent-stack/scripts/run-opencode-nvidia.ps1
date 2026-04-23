$ErrorActionPreference = "Stop"
$stackRoot = Split-Path -Parent $PSScriptRoot
$env:OPENCODE_CONFIG = Join-Path $stackRoot "opencode.json"

if (-not $env:NVIDIA_API_KEY) {
    Write-Host "NVIDIA_API_KEY nao esta definido. Veja docs/01-secrets-and-auth.md" -ForegroundColor Yellow
    exit 1
}

opencode --model nvidia/z-ai/glm5 @args
