$ErrorActionPreference = "Stop"

$stackRoot = Split-Path -Parent $PSScriptRoot

# This repo is designed to be runnable without writing to the user's home directory.
# Some environments (corporate / hardened) block writes to $HOME, AppData, etc.
# The runner scripts already set OPENCODE_CONFIG and aider config paths explicitly.

$envPath = Join-Path $stackRoot ".env"
if (-not (Test-Path -LiteralPath $envPath)) {
    Copy-Item -LiteralPath (Join-Path $stackRoot ".env.example") -Destination $envPath -Force
    Write-Host "Criado .env a partir de .env.example." -ForegroundColor Green
} else {
    Write-Host ".env ja existe." -ForegroundColor DarkGreen
}

Write-Host "Bootstrap concluido (modo portatil, sem escrever no HOME)." -ForegroundColor Green
Write-Host "Proximo passo: preencher NVIDIA_API_KEY no agent-stack/.env ou exportar na sessao. Veja docs/01-secrets-and-auth.md" -ForegroundColor Cyan
