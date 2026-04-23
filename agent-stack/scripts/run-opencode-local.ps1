$ErrorActionPreference = "Stop"
$stackRoot = Split-Path -Parent $PSScriptRoot
$toolsLib = Join-Path $PSScriptRoot "lib\\tools.ps1"
if (Test-Path -LiteralPath $toolsLib) { . $toolsLib; Use-AgentStackLocalTools }
$env:OPENCODE_CONFIG = Join-Path $stackRoot "opencode.local.json"
$env:OLLAMA_API_BASE = if ($env:OLLAMA_API_BASE) { $env:OLLAMA_API_BASE } else { "http://127.0.0.1:11434" }
$env:OLLAMA_OPENCODE_BASE = if ($env:OLLAMA_OPENCODE_BASE) { $env:OLLAMA_OPENCODE_BASE } else { "http://127.0.0.1:11434/v1" }

opencode --model ollama-local/qwen2.5-coder:7b @args
