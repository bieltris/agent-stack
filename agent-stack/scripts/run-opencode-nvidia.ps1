$ErrorActionPreference = "Stop"
$stackRoot = Split-Path -Parent $PSScriptRoot
$toolsLib = Join-Path $PSScriptRoot "lib\\tools.ps1"
if (Test-Path -LiteralPath $toolsLib) { . $toolsLib; Use-AgentStackLocalTools }
$env:OPENCODE_CONFIG = Join-Path $stackRoot "opencode.json"

if (-not $env:NVIDIA_API_KEY) {
    Write-Host "NVIDIA_API_KEY nao esta definido. Veja docs/01-secrets-and-auth.md" -ForegroundColor Yellow
    exit 1
}

opencode --model nvidia/z-ai/glm5 @args
