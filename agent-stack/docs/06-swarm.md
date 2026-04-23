# Swarm

The swarm is the first multi-agent coordination layer in this stack.

## What it does

- launches five agents in parallel
- assigns each one a distinct role
- stores each agent output separately
- writes a combined transcript
- writes a synthesized summary

## Current swarm

Defined in `swarm.json`:

- `architect`
- `planner`
- `implementer`
- `reviewer`
- `tester`

Synthesis profile:

- `max-quality`

## Run it

PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\stack.ps1 swarm "Design a login feature"
```

Bash/WSL:

```bash
./scripts/stack.sh swarm "Design a login feature"
```

## Output location

Each run is written to:

```text
.state/swarm/runs/<timestamp>/
```

Artifacts:

- `manifest.json`
- `combined.md`
- `summary.md`
- one folder per agent with `prompt.md`, `output.md`, `meta.json`

These artifacts are local runtime output. They are ignored by Git and do not need to be copied to recreate the stack elsewhere.

## Current limitations

- prompt routing is static, not dynamic
- agents do not yet edit files directly
- merge/conflict resolution is still manual
- synthesis is single-pass

## Why this matters

This is the bridge between the current CLI stack and a future orchestration GUI.
