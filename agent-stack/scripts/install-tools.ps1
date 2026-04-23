$ErrorActionPreference = "Stop"

$stackRoot = Split-Path -Parent $PSScriptRoot
$stateDir = Join-Path $stackRoot ".state"
$venvDir = Join-Path $stateDir "venv"
$nodeDir = Join-Path $stateDir "node"
$aiderConfig = Join-Path $stackRoot "config\\aider\\.aider.conf.yml"

New-Item -ItemType Directory -Force -Path $stateDir | Out-Null

if (-not (Test-Path -LiteralPath $venvDir)) {
    python -m venv $venvDir
}

$venvPython = Join-Path $venvDir "Scripts\\python.exe"
& $venvPython -m pip install --upgrade pip
& $venvPython -m pip install --upgrade aider-chat

if (-not (Test-Path -LiteralPath $nodeDir)) {
    New-Item -ItemType Directory -Force -Path $nodeDir | Out-Null
}

npm install --prefix $nodeDir opencode-ai

$binNode = Join-Path $nodeDir "node_modules\\.bin"
$binVenv = Join-Path $venvDir "Scripts"

Write-Host "Ferramentas instaladas (modo local dentro do repo)." -ForegroundColor Green
Write-Host "opencode: $binNode" -ForegroundColor Cyan
Write-Host "aider:    $binVenv" -ForegroundColor Cyan
Write-Host "aider config: $aiderConfig" -ForegroundColor DarkCyan
