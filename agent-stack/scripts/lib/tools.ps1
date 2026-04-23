$ErrorActionPreference = "Stop"

function Use-AgentStackLocalTools {
    $stackRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $stateDir = Join-Path $stackRoot ".state"

    $nodeBin = Join-Path $stateDir "node\\node_modules\\.bin"
    if (Test-Path -LiteralPath $nodeBin) {
        $env:Path = "$nodeBin;$env:Path"
    }

    $venvBin = Join-Path $stateDir "venv\\Scripts"
    if (Test-Path -LiteralPath $venvBin) {
        $env:Path = "$venvBin;$env:Path"
    }
}
