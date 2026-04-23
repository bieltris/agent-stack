#!/usr/bin/env bash
set -euo pipefail

has() { command -v "$1" >/dev/null 2>&1; }

echo "opencode=$(has opencode && echo true || echo false)"
echo "aider=$(has aider && echo true || echo false)"
echo "docker=$(has docker && echo true || echo false)"
echo "ollama=$(has ollama && echo true || echo false)"
echo "nvidia_api_key=$([[ -n "${NVIDIA_API_KEY:-}" ]] && echo true || echo false)"
echo "ollama_api_base=$([[ -n "${OLLAMA_API_BASE:-}" ]] && echo true || echo false)"
