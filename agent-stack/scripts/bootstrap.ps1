$ErrorActionPreference = "Stop"

$stackRoot = Split-Path -Parent $PSScriptRoot
$homeConfig = Join-Path $HOME ".config\opencode"
$homeAider = Join-Path $HOME ".aider.conf.yml"

New-Item -ItemType Directory -Force -Path $homeConfig | Out-Null
Copy-Item -Force (Join-Path $stackRoot "opencode.json") (Join-Path $homeConfig "opencode.json")
Copy-Item -Force (Join-Path $stackRoot "opencode.local.json") (Join-Path $homeConfig "opencode.local.json")
Copy-Item -Force (Join-Path $stackRoot "config\aider\.aider.conf.yml") $homeAider

[Environment]::SetEnvironmentVariable("OLLAMA_API_BASE", "http://127.0.0.1:11434", "User")
[Environment]::SetEnvironmentVariable("AGENT_STACK_ROOT", $stackRoot, "User")

Write-Host "Bootstrap concluido." -ForegroundColor Green
Write-Host "Agora leia docs/01-secrets-and-auth.md para concluir NVIDIA_API_KEY." -ForegroundColor Cyan
