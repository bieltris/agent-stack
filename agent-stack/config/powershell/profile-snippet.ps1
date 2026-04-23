$env:OLLAMA_API_BASE = "http://127.0.0.1:11434"
$env:OLLAMA_OPENCODE_BASE = "http://127.0.0.1:11434/v1"

function Start-OpenCodeNvidia {
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$OpenCodeArgs
    )

    if (-not $env:NVIDIA_API_KEY) {
        Write-Host "NVIDIA_API_KEY nao esta definido. Veja agent-stack/docs/01-secrets-and-auth.md" -ForegroundColor Yellow
        return
    }

    $env:OPENCODE_CONFIG = "D:\Usuarios\Gabriel\Documents\New project\agent-stack\opencode.json"
    opencode --model nvidia/glm5 @OpenCodeArgs
}

function Start-OpenCodeLocal {
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$OpenCodeArgs
    )

    $env:OPENCODE_CONFIG = "D:\Usuarios\Gabriel\Documents\New project\agent-stack\opencode.local.json"
    opencode --model ollama-local/qwen2.5-coder:7b @OpenCodeArgs
}

function Start-OpenCodeProfile {
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ProfileName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$OpenCodeArgs
    )

    powershell -ExecutionPolicy Bypass -File "D:\Usuarios\Gabriel\Documents\New project\agent-stack\scripts\run-opencode-profile.ps1" $ProfileName @OpenCodeArgs
}

function Start-AgentStack {
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$StackArgs
    )

    powershell -ExecutionPolicy Bypass -File "D:\Usuarios\Gabriel\Documents\New project\agent-stack\scripts\stack.ps1" @StackArgs
}

function openfast { Start-OpenCodeProfile fast @args }
function opencheap { Start-OpenCodeProfile cheap @args }
function openlocalonly { Start-OpenCodeProfile local-only @args }
function openmax { Start-OpenCodeProfile max-quality @args }
Set-Alias -Name stack -Value Start-AgentStack
