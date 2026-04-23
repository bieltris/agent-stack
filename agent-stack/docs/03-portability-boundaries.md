# Portability Boundaries

This stack is designed to make a future setup fast, not to be a full disk image.

## Portable inside this folder

- OpenCode config
- aider config
- Docker workflow
- helper scripts
- setup docs
- model/provider choices

## Not portable as plain files

- GUI apps already installed on the host
- secrets already stored in credential managers
- live cloud sessions
- GPU drivers and Docker Desktop internals
- Ollama model blobs if you choose not to copy them separately

## Best strategy on another PC

1. Install the host prerequisites.
2. Copy this folder.
3. Let an agent read `AGENTS.md` and the docs.
4. Rehydrate secrets manually.
5. Re-pull local models if needed.
