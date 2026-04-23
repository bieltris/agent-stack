# Start Here

This stack is split into two layers:

- primary cloud workflow: `OpenCode + NVIDIA`
- local fallback workflow: `aider + Ollama`

## New machine checklist

1. Install Docker Desktop.
2. Install Node.js 22+ if you want host-native `opencode`.
3. Install Python 3.12+ if you want host-native `aider`.
4. Install Ollama on the host.
5. Copy this folder.
6. Create `.env` from `.env.example`.
7. Run `scripts/bootstrap.ps1` on Windows or `scripts/bootstrap.sh` on Linux/macOS/WSL.
8. Complete `docs/01-secrets-and-auth.md`.
9. Run `scripts/doctor.ps1`.

## Recommended daily commands

- `powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-nvidia.ps1`
- `powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-local.ps1`
- `powershell -ExecutionPolicy Bypass -File .\scripts\run-aider.ps1`
- `docker compose run --rm agent-stack bash`
