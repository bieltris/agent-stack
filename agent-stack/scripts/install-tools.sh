#!/usr/bin/env bash
set -euo pipefail

STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="${STACK_ROOT}/.state"
VENV_DIR="${STATE_DIR}/venv"
NODE_DIR="${STATE_DIR}/node"

mkdir -p "${STATE_DIR}"

if [[ ! -d "${VENV_DIR}" ]]; then
  python3 -m venv "${VENV_DIR}"
fi

"${VENV_DIR}/bin/python" -m pip install --upgrade pip
"${VENV_DIR}/bin/python" -m pip install --upgrade aider-chat

mkdir -p "${NODE_DIR}"
npm install --prefix "${NODE_DIR}" opencode-ai

echo "Ferramentas instaladas (modo local dentro do repo)."
echo "opencode: ${NODE_DIR}/node_modules/.bin"
echo "aider:    ${VENV_DIR}/bin"
