# Current Machine Manual Steps

These are the pieces that cannot be fully portable inside this folder.

Also note:

- the `.state/` folder contains local runtime output from swarm runs and should not be treated as setup input
- `.env` stays local and is intentionally ignored by Git

## Warp

Reason:

- GUI app install lives outside the stack folder.

Status on this machine:

- already installed separately

## Ollama host service

Reason:

- best performance comes from running Ollama on the host, not inside the container
- large model files should stay outside the stack folder

What to do on a new machine:

1. Install Ollama.
2. Pull the fallback model:

```powershell
ollama pull qwen2.5-coder:7b
```

3. Start the service:

```powershell
ollama serve
```

4. The OpenCode local fallback expects the OpenAI-compatible endpoint:

```text
http://127.0.0.1:11434/v1
```

## Stored auth in native credential stores

Reason:

- credential stores are machine-specific and should not be copied around

Examples:

- GitHub Copilot auth
- Codex local login state
- browser/device-flow approvals
- NVIDIA API key if you chose to store it outside project-local files
