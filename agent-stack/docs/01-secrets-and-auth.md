# Secrets And Auth

This folder intentionally does not contain real secrets.

## Manual item 1: NVIDIA API key

Why manual:

- API keys should not be baked into files, images, or Git history.

What to do:

1. Create or sign in to an account at `https://build.nvidia.com`.
2. Generate an API key.
3. Set `NVIDIA_API_KEY` on the host machine.

Windows PowerShell:

```powershell
[Environment]::SetEnvironmentVariable("NVIDIA_API_KEY", "nvapi-...", "User")
```

Current terminal only:

```powershell
$env:NVIDIA_API_KEY = "nvapi-..."
```

Docker `.env` file:

```dotenv
NVIDIA_API_KEY=nvapi-...
```

## Manual item 2: verify OpenCode can see the key

If you installed tools locally into `.state/`, prefer:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run-opencode-profile.ps1 fast models nvidia
```

or:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 run fast models nvidia
```

If you installed `opencode` globally, this also works:

```powershell
opencode models nvidia
```

If that does not work, use the stack config explicitly:

```powershell
$env:OPENCODE_CONFIG = (Resolve-Path .\opencode.json).Path
opencode models nvidia
```

Linux/macOS/WSL:

```bash
export NVIDIA_API_KEY="nvapi-..."
./scripts/run-opencode-profile.sh fast models nvidia
```

## Manual item 3: model switching

Primary:

- `nvidia/z-ai/glm5`

Alternatives:

- `nvidia/moonshotai/kimi-k2.5`
- `nvidia/minimaxai/minimax-m2.5`
- `nvidia/nvidia/nvidia-nemotron-nano-9b-v2`

Local fallback:

- `ollama-local/qwen2.5-coder:7b`
