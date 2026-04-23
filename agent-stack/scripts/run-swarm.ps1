param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Task,

    [Parameter(Position = 1)]
    [string]$SwarmName = "default"
)

$ErrorActionPreference = "Stop"

$stackRoot = Split-Path -Parent $PSScriptRoot
$swarmConfigPath = Join-Path $stackRoot "swarm.json"
$profilesPath = Join-Path $stackRoot "profiles.json"
$swarmConfig = Get-Content $swarmConfigPath -Raw | ConvertFrom-Json
$profiles = Get-Content $profilesPath -Raw | ConvertFrom-Json

if (-not ($swarmConfig.PSObject.Properties.Name -contains $SwarmName)) {
    Write-Host "Swarm invalido: $SwarmName" -ForegroundColor Red
    Write-Host "Swarms disponiveis: $($swarmConfig.PSObject.Properties.Name -join ', ')" -ForegroundColor Yellow
    exit 1
}

$swarm = $swarmConfig.$SwarmName
$runId = Get-Date -Format "yyyyMMdd-HHmmss"
$runRoot = Join-Path $stackRoot ".state\swarm\runs\$runId"
$null = New-Item -ItemType Directory -Force -Path $runRoot

function Invoke-ProfileScript {
    param(
        [string]$ScriptPath,
        [string]$Profile,
        [string]$PromptFile
    )

    $stdoutPath = [System.IO.Path]::GetTempFileName()
    $stderrPath = [System.IO.Path]::GetTempFileName()
    $argList = "-ExecutionPolicy Bypass -File `"$ScriptPath`" `"$Profile`" -PromptFile `"$PromptFile`""
    $process = Start-Process -FilePath "powershell.exe" -ArgumentList $argList -PassThru -Wait -NoNewWindow -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath
    $stdout = if (Test-Path $stdoutPath) { Get-Content $stdoutPath -Raw -Encoding UTF8 } else { "" }
    $stderr = if (Test-Path $stderrPath) { Get-Content $stderrPath -Raw -Encoding UTF8 } else { "" }
    Remove-Item $stdoutPath, $stderrPath -Force -ErrorAction SilentlyContinue

    [pscustomobject]@{
        ExitCode = $process.ExitCode
        StdOut = $stdout
        StdErr = $stderr
    }
}

function Normalize-AgentOutput {
    param([string]$Text)

    if (-not $Text) {
        return ""
    }

    $normalized = $Text -replace "\x1b\[[0-9;?]*[A-Za-z]", ""
    $normalized = $normalized -replace "(?m)^OpenCode profile:.*\r?\n?", ""
    $normalized = $normalized -replace "(?m)^> build .*?\r?\n?", ""
    $normalized = $normalized -replace "(?m)^.*build .*?\r?\n?", ""
    $normalized = $normalized -replace "(?m)^[\u00B7\u2022]\s+[A-Za-z0-9_.-]+/[A-Za-z0-9_.:-]+\s*$\r?\n?", ""
    $normalized = $normalized -replace "(?m)^model:\s+[A-Za-z0-9_.-]+/[A-Za-z0-9_.:-]+\s*$\r?\n?", ""
    $normalized = $normalized -replace "(?m)^[^\p{L}\p{N}#\-\*\|`].*$\r?\n?", ""
    return $normalized.Trim()
}

$manifest = [ordered]@{
    runId = $runId
    swarm = $SwarmName
    task = $Task
    createdAt = (Get-Date).ToString("o")
    agents = @()
}

$processRecords = @()

foreach ($agent in $swarm.agents) {
    $agentName = $agent.name
    $profileName = $agent.profile
    $agentDir = Join-Path $runRoot $agentName
    $null = New-Item -ItemType Directory -Force -Path $agentDir

    $prompt = @"
You are agent '$agentName' in the '$SwarmName' swarm.

Primary goal:
$($agent.goal)

User task:
$Task

Output requirements:
- Be concise but useful.
- Focus on your role only.
- Use markdown.
- Include specific recommendations.
- Do not mention that you are an AI model.
"@

    $promptPath = Join-Path $agentDir "prompt.md"
    $outputPath = Join-Path $agentDir "output.md"
    $metaPath = Join-Path $agentDir "meta.json"
    Set-Content -Path $promptPath -Value $prompt -Encoding UTF8

    $manifest.agents += [ordered]@{
        name = $agentName
        profile = $profileName
        goal = $agent.goal
        prompt = $promptPath
        output = $outputPath
    }

    $stdoutPath = Join-Path $agentDir "stdout.log"
    $stderrPath = Join-Path $agentDir "stderr.log"
    $argList = "-ExecutionPolicy Bypass -File `"$((Join-Path $PSScriptRoot "run-opencode-profile.ps1"))`" `"$profileName`" -PromptFile `"$promptPath`""
    $startedAt = Get-Date
    $process = Start-Process -FilePath "powershell.exe" -ArgumentList $argList -PassThru -WindowStyle Hidden -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath

    $processRecords += [pscustomobject]@{
        Agent = $agentName
        Profile = $profileName
        Process = $process
        AgentDir = $agentDir
        OutputPath = $outputPath
        MetaPath = $metaPath
        StdOutPath = $stdoutPath
        StdErrPath = $stderrPath
        StartedAt = $startedAt
    }
}

Write-Host "Swarm '$SwarmName' iniciado com $($processRecords.Count) agentes." -ForegroundColor Cyan
Write-Host "Run directory: $runRoot" -ForegroundColor Cyan

$processRecords | ForEach-Object {
    $_.Process.WaitForExit()
    $_.Process.Refresh()
    $stdout = if (Test-Path $_.StdOutPath) { Get-Content $_.StdOutPath -Raw -Encoding UTF8 } else { "" }
    $stderr = if (Test-Path $_.StdErrPath) { Get-Content $_.StdErrPath -Raw -Encoding UTF8 } else { "" }
    $result = ($stdout, $stderr | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join [Environment]::NewLine
    Set-Content -Path $_.OutputPath -Value (Normalize-AgentOutput $result) -Encoding UTF8
    $meta = [ordered]@{
        startedAt = $_.StartedAt.ToString("o")
        finishedAt = (Get-Date).ToString("o")
        exitCode = [int]$_.Process.ExitCode
        profile = $_.Profile
    } | ConvertTo-Json -Depth 4
    Set-Content -Path $_.MetaPath -Value $meta -Encoding UTF8
    Remove-Item $_.StdOutPath, $_.StdErrPath -Force -ErrorAction SilentlyContinue
}

$combinedPath = Join-Path $runRoot "combined.md"
$summaryPath = Join-Path $runRoot "summary.md"
$manifestPath = Join-Path $runRoot "manifest.json"

$combined = @("# Swarm Run", "", "- Run: $runId", "- Swarm: $SwarmName", "- Task: $Task", "")

foreach ($agent in $swarm.agents) {
    $agentName = $agent.name
    $agentDir = Join-Path $runRoot $agentName
    $outputPath = Join-Path $agentDir "output.md"
    $metaPath = Join-Path $agentDir "meta.json"
    $meta = Get-Content $metaPath -Raw | ConvertFrom-Json
    $content = Get-Content $outputPath -Raw

    $combined += "## $agentName"
    $combined += ""
    $combined += "- Profile: $($agent.profile)"
    $combined += "- ExitCode: $($meta.exitCode)"
    $combined += ""
    $combined += $content
    $combined += ""
}

Set-Content -Path $combinedPath -Value ($combined -join [Environment]::NewLine) -Encoding UTF8
Set-Content -Path $manifestPath -Value (($manifest | ConvertTo-Json -Depth 6)) -Encoding UTF8

$synthesisProfile = $swarm.synthesisProfile
$summaryPrompt = @"
You are synthesizing the outputs of a multi-agent software swarm.

Task:
$Task

Instructions:
- Read the combined swarm output.
- Produce a concise executive summary.
- Include sections: Recommended Plan, Risks, Testing Focus, Best Next Action.
- Prefer decisive conclusions over listing everything.

Combined swarm output follows:

$(Get-Content $combinedPath -Raw)
"@

$summaryPromptPath = Join-Path $runRoot "summary-prompt.md"
Set-Content -Path $summaryPromptPath -Value $summaryPrompt -Encoding UTF8

try {
    $summaryResult = Invoke-ProfileScript -ScriptPath (Join-Path $PSScriptRoot "run-opencode-profile.ps1") -Profile $synthesisProfile -PromptFile $summaryPromptPath
    if ($summaryResult.ExitCode -ne 0) {
        throw $summaryResult.StdErr
    }
    $summary = ($summaryResult.StdOut, $summaryResult.StdErr | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join [Environment]::NewLine
    Set-Content -Path $summaryPath -Value (Normalize-AgentOutput $summary) -Encoding UTF8
} catch {
    $fallbackSummary = @(
        "# Swarm Summary",
        "",
        "Automatic synthesis failed.",
        "",
        "Read the combined output here:",
        $combinedPath
    ) -join [Environment]::NewLine
    Set-Content -Path $summaryPath -Value $fallbackSummary -Encoding UTF8
}

Write-Host ""
Write-Host "Swarm complete." -ForegroundColor Green
Write-Host "Combined output: $combinedPath" -ForegroundColor Green
Write-Host "Summary: $summaryPath" -ForegroundColor Green
