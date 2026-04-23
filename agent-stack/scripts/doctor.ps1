$stackRoot = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $stackRoot ".env"
$savedNvidiaKey = [System.Environment]::GetEnvironmentVariable("NVIDIA_API_KEY", "User")
$savedOllamaBase = [System.Environment]::GetEnvironmentVariable("OLLAMA_API_BASE", "User")
$savedOllamaOpenCodeBase = [System.Environment]::GetEnvironmentVariable("OLLAMA_OPENCODE_BASE", "User")
$dotenv = @{}

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
    "nvidia_api_key" = -not [string]::IsNullOrWhiteSpace($env:NVIDIA_API_KEY) -or -not [string]::IsNullOrWhiteSpace($savedNvidiaKey) -or $dotenv.ContainsKey("NVIDIA_API_KEY")
    "ollama_api_base" = -not [string]::IsNullOrWhiteSpace($env:OLLAMA_API_BASE) -or -not [string]::IsNullOrWhiteSpace($savedOllamaBase) -or $dotenv.ContainsKey("OLLAMA_API_BASE")
    "ollama_opencode_base" = -not [string]::IsNullOrWhiteSpace($env:OLLAMA_OPENCODE_BASE) -or -not [string]::IsNullOrWhiteSpace($savedOllamaOpenCodeBase) -or $dotenv.ContainsKey("OLLAMA_OPENCODE_BASE")
}

$checks.GetEnumerator() | ForEach-Object {
    [pscustomobject]@{
        Check = $_.Key
        Ok = $_.Value
    }
} | Format-Table -AutoSize
