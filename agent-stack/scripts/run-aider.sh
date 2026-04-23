#!/usr/bin/env bash
set -euo pipefail

export OLLAMA_API_BASE="${OLLAMA_API_BASE:-http://127.0.0.1:11434}"
exec aider "$@"
