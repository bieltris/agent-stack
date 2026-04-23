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
6. Create `.env` from `.env.example` if you plan to use Docker Compose.
7. Run `scripts/bootstrap.ps1` on Windows or `scripts/bootstrap.sh` on Linux/macOS/WSL.
8. Complete `docs/01-secrets-and-auth.md`.
9. Open a new terminal if your OS persists env vars outside the current shell.
10. Run `scripts/doctor.ps1` on Windows or `scripts/doctor.sh` on Linux/macOS/WSL.

## Recommended daily commands

- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 profiles`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run fast`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run cheap`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run local-only`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run max-quality`
- `powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 swarm "Design a login feature"`
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

## Important portability notes

- `scripts/bootstrap.ps1` copies config files and saves `AGENT_STACK_ROOT` and `OLLAMA_API_BASE` as user environment variables for future PowerShell sessions.
- `scripts/bootstrap.sh` copies config files only. For host-native bash or WSL usage, export `NVIDIA_API_KEY`, `OLLAMA_API_BASE`, and `OLLAMA_OPENCODE_BASE` in your shell profile or before running commands.
- `.env` is consumed by Docker Compose. It is not automatically loaded into your host shell.
