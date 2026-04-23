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

- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 profiles`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run fast`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run cheap`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run local-only`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run max-quality`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 aider`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 doctor`
- `powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-nvidia.ps1`
- `powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-local.ps1`
- `powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-profile.ps1 fast`
- `powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-profile.ps1 cheap`
- `powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-profile.ps1 local-only`
- `powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-profile.ps1 max-quality`
- `powershell -ExecutionPolicy Bypass -File .\scripts\run-aider.ps1`
- `docker compose run --rm agent-stack bash`

Linux/macOS/WSL (bash):

- `./scripts/stack.sh profiles`
- `./scripts/stack.sh run fast`
- `./scripts/stack.sh run local-only`
- `./scripts/stack.sh aider`
- `./scripts/stack.sh doctor`
