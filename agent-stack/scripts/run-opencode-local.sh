#!/usr/bin/env bash
set -euo pipefail

STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export OPENCODE_CONFIG="${STACK_ROOT}/opencode.local.json"
export OLLAMA_API_BASE="${OLLAMA_API_BASE:-http://127.0.0.1:11434}"
export OLLAMA_OPENCODE_BASE="${OLLAMA_OPENCODE_BASE:-http://127.0.0.1:11434/v1}"

exec opencode --model ollama-local/qwen2.5-coder:7b "$@"
