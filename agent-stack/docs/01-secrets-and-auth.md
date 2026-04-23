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

```powershell
opencode models nvidia
```

If that does not work, use the stack config explicitly:

```powershell
$env:OPENCODE_CONFIG = "D:\path\to\agent-stack\opencode.json"
opencode models nvidia
```

## Manual item 3: model switching

Primary:

- `nvidia/glm5`

Alternatives:

- `nvidia/kimi-k2.5`
- `nvidia/minimax-m2.5`

Local fallback:

- `ollama-local/qwen2.5-coder:7b`
