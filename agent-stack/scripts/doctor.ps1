$checks = [ordered]@{
    "opencode" = (Get-Command opencode -ErrorAction SilentlyContinue) -ne $null
    "aider" = (Get-Command aider -ErrorAction SilentlyContinue) -ne $null
    "docker" = (Get-Command docker -ErrorAction SilentlyContinue) -ne $null
    "ollama" = (Get-Command ollama -ErrorAction SilentlyContinue) -ne $null
    "nvidia_api_key" = -not [string]::IsNullOrWhiteSpace($env:NVIDIA_API_KEY)
    "ollama_api_base" = -not [string]::IsNullOrWhiteSpace($env:OLLAMA_API_BASE)
}

$checks.GetEnumerator() | ForEach-Object {
    [pscustomobject]@{
        Check = $_.Key
        Ok = $_.Value
    }
} | Format-Table -AutoSize
