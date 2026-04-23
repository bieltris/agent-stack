# Profiles

These profiles are opinionated defaults for `OpenCode`.

They are not sacred. They are meant to make it easy to switch behavior quickly.

## fast

- model: `nvidia/minimaxai/minimax-m2.5`
- goal: faster cloud interaction for quick coding loops
- use when: you want short responses, fast edits, fast iteration

## cheap

- model: `nvidia/nvidia/nvidia-nemotron-nano-9b-v2`
- goal: minimal cloud cost for low-stakes work
- use when: you are triaging, drafting, or testing the workflow itself

## local-only

- model: `ollama-local/qwen2.5-coder:7b`
- goal: keep working with no cloud dependency
- use when: you want privacy, resilience, or no external spend

## max-quality

- model: `nvidia/z-ai/glm5`
- goal: strongest default quality in this stack
- use when: the task matters more than latency or cost

## Suggested habit

- start with `fast`
- drop to `cheap` for rough work
- switch to `local-only` when cloud is unavailable or unnecessary
- move to `max-quality` for the hard stuff
