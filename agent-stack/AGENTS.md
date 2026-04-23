# Agent Stack Bootstrap

Read these files in order when setting up this stack on another machine:

1. `README.md`
2. `docs/00-start-here.md`
3. `docs/01-secrets-and-auth.md`
4. `docs/02-current-machine-manual-steps.md`
5. `docs/03-portability-boundaries.md`

Key goals:

- Recreate `OpenCode + NVIDIA` as the main cloud coding stack.
- Recreate `aider + Ollama` as the local fallback stack.
- Reuse `opencode.json` and `config/aider/.aider.conf.yml` instead of inventing new config.
- Prefer the scripts in `scripts/` over ad-hoc manual commands.

Important constraints:

- Do not commit real secrets into this folder.
- Use `.env` from `.env.example`.
- Keep `Ollama` on the host machine, not inside the container.
- Treat Warp and other GUI tools as optional host extras.
