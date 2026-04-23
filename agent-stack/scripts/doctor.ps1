$toolsLib = Join-Path $PSScriptRoot "lib\tools.ps1"
if (Test-Path -LiteralPath $toolsLib) {
    . $toolsLib
    Use-AgentStackLocalTools
}

$stackRoot = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $stackRoot ".env"
$savedNvidiaKey = [System.Environment]::GetEnvironmentVariable("NVIDIA_API_KEY", "User")
$savedOllamaBase = [System.Environment]::GetEnvironmentVariable("OLLAMA_API_BASE", "User")
$savedOllamaOpenCodeBase = [System.Environment]::GetEnvironmentVariable("OLLAMA_OPENCODE_BASE", "User")
$dotenv = @{}

function Test-ConfiguredValue {
    param(
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $false
    }

    $normalized = $Value.Trim()
    return $normalized -notmatch "REPLACE_ME|CHANGE_ME|YOUR_"
}

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*#' -or $_ -match '^\s*$') {
            return
        }
        $parts = $_ -split '=', 2
        if ($parts.Count -eq 2) {
            $dotenv[$parts[0].Trim()] = $parts[1].Trim()
        }
    }
}

$checks = [ordered]@{
    "opencode" = (Get-Command opencode -ErrorAction SilentlyContinue) -ne $null
    "aider" = (Get-Command aider -ErrorAction SilentlyContinue) -ne $null
    "docker" = (Get-Command docker -ErrorAction SilentlyContinue) -ne $null
    "ollama" = (Get-Command ollama -ErrorAction SilentlyContinue) -ne $null
    "nvidia_api_key" = (Test-ConfiguredValue $env:NVIDIA_API_KEY) -or (Test-ConfiguredValue $savedNvidiaKey) -or (Test-ConfiguredValue $dotenv["NVIDIA_API_KEY"])
    "ollama_api_base" = (Test-ConfiguredValue $env:OLLAMA_API_BASE) -or (Test-ConfiguredValue $savedOllamaBase) -or (Test-ConfiguredValue $dotenv["OLLAMA_API_BASE"])
    "ollama_opencode_base" = (Test-ConfiguredValue $env:OLLAMA_OPENCODE_BASE) -or (Test-ConfiguredValue $savedOllamaOpenCodeBase) -or (Test-ConfiguredValue $dotenv["OLLAMA_OPENCODE_BASE"])
}

$checks.GetEnumerator() | ForEach-Object {
    [pscustomobject]@{
        Check = $_.Key
        Ok = $_.Value
    }
} | Format-Table -AutoSize
