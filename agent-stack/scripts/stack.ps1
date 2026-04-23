param(
    [Parameter(Position = 0)]
    [string]$Command = "help",

    [Parameter(Position = 1)]
    [string]$Target,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$ErrorActionPreference = "Stop"

$stackRoot = Split-Path -Parent $PSScriptRoot
$profilesPath = Join-Path $stackRoot "profiles.json"
$profiles = Get-Content $profilesPath -Raw | ConvertFrom-Json

function Show-StackHelp {
    @"
Agent Stack Command Center

Usage:
  stack help
  stack profiles
  stack run <fast|cheap|local-only|max-quality> [opencode args...]
  stack swarm "<task>" [swarm-name]
  stack aider [aider args...]
  stack doctor
  stack status
  stack opencode-nvidia [opencode args...]
  stack opencode-local [opencode args...]
  stack bootstrap
"@ | Write-Host
}

function Show-Profiles {
    $profiles.PSObject.Properties | ForEach-Object {
        $name = $_.Name
        $profile = $_.Value
        [pscustomobject]@{
            Profile  = $name
            Label    = $profile.label
            Provider = $profile.provider
            Model    = $profile.model
            Intent   = $profile.intent
        }
    } | Format-Table -Wrap -AutoSize
}

function Show-Status {
    $savedNvidiaKey = [System.Environment]::GetEnvironmentVariable("NVIDIA_API_KEY", "User")
    $ollamaUp = $false
    try {
        ollama list *> $null
        $ollamaUp = $true
    } catch {
        $ollamaUp = $false
    }

    [pscustomobject]@{
        opencode_installed = (Get-Command opencode -ErrorAction SilentlyContinue) -ne $null
        aider_installed = (Get-Command aider -ErrorAction SilentlyContinue) -ne $null
        docker_installed = (Get-Command docker -ErrorAction SilentlyContinue) -ne $null
        ollama_installed = (Get-Command ollama -ErrorAction SilentlyContinue) -ne $null
        ollama_running = $ollamaUp
        nvidia_key_in_session = -not [string]::IsNullOrWhiteSpace($env:NVIDIA_API_KEY)
        nvidia_key_saved_user = -not [string]::IsNullOrWhiteSpace($savedNvidiaKey)
    } | Format-List
}

switch ($Command) {
    "help" {
        Show-StackHelp
    }
    "profiles" {
        Show-Profiles
    }
    "run" {
        if (-not $Target) {
            Write-Host "Missing profile name." -ForegroundColor Red
            Show-StackHelp
            exit 1
        }
        powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "run-opencode-profile.ps1") $Target @Args
    }
    "swarm" {
        if (-not $Target) {
            Write-Host "Missing task text." -ForegroundColor Red
            Show-StackHelp
            exit 1
        }
        $swarmName = if ($Args.Count -gt 0) { $Args[0] } else { "default" }
        powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "run-swarm.ps1") $Target $swarmName
    }
    "aider" {
        powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "run-aider.ps1") @($Target) @Args
    }
    "doctor" {
        powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "doctor.ps1")
    }
    "status" {
        Show-Status
    }
    "opencode-nvidia" {
        powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "run-opencode-nvidia.ps1") @($Target) @Args
    }
    "opencode-local" {
        powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "run-opencode-local.ps1") @($Target) @Args
    }
    "bootstrap" {
        powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "bootstrap.ps1")
    }
    default {
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Show-StackHelp
        exit 1
    }
}
