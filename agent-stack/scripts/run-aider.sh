#!/usr/bin/env bash
set -euo pipefail

export OLLAMA_API_BASE="${OLLAMA_API_BASE:-http://127.0.0.1:11434}"
STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec aider --config "${STACK_ROOT}/config/aider/.aider.conf.yml" "$@"
