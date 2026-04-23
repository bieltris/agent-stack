# Command Center

The command center is the single CLI entrypoint for operating the stack.

## Why it exists

Without it, you need to remember several separate scripts and aliases.

With it, you can operate the stack through one command surface:

- `stack profiles`
- `stack run fast`
- `stack run cheap`
- `stack run local-only`
- `stack run max-quality`
- `stack swarm "Design a login feature"`
- `stack aider`
- `stack doctor`
- `stack status`

Implementation:

- PowerShell: `scripts/stack.ps1`
- Bash: `scripts/stack.sh`

## Design goals

- one entrypoint
- minimal memory load
- profile-first workflow
- reuse existing scripts instead of duplicating logic

## Suggested future expansion

- model switching
- automatic cloud to local fallback
- smarter agent routing
- GUI frontend using the same command primitives
