#!/usr/bin/env bash
set -euo pipefail

has() { command -v "$1" >/dev/null 2>&1; }
configured() {
  local value="${1:-}"
  [[ -n "${value}" && ! "${value}" =~ REPLACE_ME|CHANGE_ME|YOUR_ ]]
}

STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NODE_BIN="${STACK_ROOT}/.state/node/node_modules/.bin"
VENV_BIN="${STACK_ROOT}/.state/venv/bin"

if [[ -d "${NODE_BIN}" ]]; then export PATH="${NODE_BIN}:${PATH}"; fi
if [[ -d "${VENV_BIN}" ]]; then export PATH="${VENV_BIN}:${PATH}"; fi

if [[ -f "${STACK_ROOT}/.env" ]]; then
  set -a
  . "${STACK_ROOT}/.env"
  set +a
fi

echo "opencode=$(has opencode && echo true || echo false)"
echo "aider=$(has aider && echo true || echo false)"
echo "docker=$(has docker && echo true || echo false)"
echo "ollama=$(has ollama && echo true || echo false)"
echo "nvidia_api_key=$(configured "${NVIDIA_API_KEY:-}" && echo true || echo false)"
echo "ollama_api_base=$(configured "${OLLAMA_API_BASE:-}" && echo true || echo false)"
echo "ollama_opencode_base=$(configured "${OLLAMA_OPENCODE_BASE:-}" && echo true || echo false)"
