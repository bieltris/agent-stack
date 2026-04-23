$ErrorActionPreference = "Stop"
$stackRoot = Split-Path -Parent $PSScriptRoot
$toolsLib = Join-Path $PSScriptRoot "lib\\tools.ps1"
if (Test-Path -LiteralPath $toolsLib) { . $toolsLib; Use-AgentStackLocalTools }
$env:OLLAMA_API_BASE = if ($env:OLLAMA_API_BASE) { $env:OLLAMA_API_BASE } else { "http://127.0.0.1:11434" }

$aiderConfig = Join-Path $stackRoot "config\\aider\\.aider.conf.yml"
aider --config $aiderConfig @args
