$ErrorActionPreference = "Stop"

$stackRoot = Split-Path -Parent $PSScriptRoot
$stateDir = Join-Path $stackRoot ".state"
$venvDir = Join-Path $stateDir "venv"
$nodeDir = Join-Path $stateDir "node"
$aiderConfig = Join-Path $stackRoot "config\\aider\\.aider.conf.yml"

New-Item -ItemType Directory -Force -Path $stateDir | Out-Null

function Get-Python312Path {
    $py = Get-Command py -ErrorAction SilentlyContinue
    if (-not $py) { return $null }
    try {
        $exe = & py -3.12 -c "import sys; print(sys.executable)"
        if ($LASTEXITCODE -ne 0) { return $null }
        return $exe.Trim()
    } catch {
        return $null
    }
}

$python312 = Get-Python312Path
if (-not $python312) {
    throw "Python 3.12 nao encontrado. Instale via winget: winget install -e --id Python.Python.3.12"
}

if (Test-Path -LiteralPath $venvDir) {
    $existing = Join-Path $venvDir "Scripts\\python.exe"
    if (Test-Path -LiteralPath $existing) {
        $ver = & $existing --version 2>$null
        if ($ver -notmatch "^Python 3\\.12\\.") {
            Remove-Item -LiteralPath $venvDir -Recurse -Force
        }
    }
}

if (-not (Test-Path -LiteralPath $venvDir)) {
    & $python312 -m venv $venvDir
}

$venvPython = Join-Path $venvDir "Scripts\\python.exe"
& $venvPython -m pip install --upgrade pip setuptools wheel
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
