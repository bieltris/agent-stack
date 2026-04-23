# Agent Stack

Portable AI agent stack for:

- `OpenCode + NVIDIA` as the primary cloud coding workflow
- `aider + Ollama` as the local fallback workflow

This folder is designed so a future agent can read it and finish setup quickly on another PC.

## What is included

- portable config for `OpenCode`
- portable config for `aider`
- Docker-based workflow shell
- PowerShell and shell bootstrap scripts
- docs for everything that cannot safely be bundled

## Fast path on a new machine

1. Copy this folder to the new machine.
2. Create `.env` from `.env.example`.
3. Read `docs/00-start-here.md`.
4. Run the bootstrap script for your OS.
5. Complete the manual steps in `docs/01-secrets-and-auth.md`.

## Main entrypoints

- `scripts/stack.ps1`
- `scripts/bootstrap.ps1`
- `scripts/doctor.ps1`
- `scripts/run-opencode-nvidia.ps1`
- `scripts/run-opencode-local.ps1`
- `scripts/run-opencode-profile.ps1`
- `scripts/run-aider.ps1`
- `docker compose run --rm agent-stack bash`

## Command Center

The command center is the unified CLI entrypoint for the stack.

PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 help
powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 profiles
powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run fast
powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run max-quality
powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 aider
powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 doctor
```

Shell:

```bash
./scripts/stack.sh profiles
./scripts/stack.sh run local-only
```

## Profiles

The stack includes four OpenCode profiles:

- `fast`: `nvidia/minimaxai/minimax-m2.5`
- `cheap`: `nvidia/nvidia/nvidia-nemotron-nano-9b-v2`
- `local-only`: Ollama-only fallback
- `max-quality`: `nvidia/z-ai/glm5`

PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-profile.ps1 fast
powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-profile.ps1 max-quality
```

Shell:

```bash
./scripts/run-opencode-profile.sh fast
./scripts/run-opencode-profile.sh local-only
```

## Notes

- `OpenCode` is configured to use the NVIDIA OpenAI-compatible endpoint.
- `OpenCode` also includes a fully local config in `opencode.local.json`.
- `aider` is configured to use `ollama/qwen2.5-coder:7b`.
- `Ollama` is expected to run on the host at `http://127.0.0.1:11434`.
- `OpenCode` talks to Ollama through the OpenAI-compatible endpoint `/v1`.
- If you use `config/powershell/profile-snippet.ps1`, run `scripts/bootstrap.ps1` first so `AGENT_STACK_ROOT` is set.
