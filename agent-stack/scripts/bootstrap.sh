#!/usr/bin/env bash
set -euo pipefail

STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "${HOME}/.config/opencode"
cp "${STACK_ROOT}/opencode.json" "${HOME}/.config/opencode/opencode.json"
cp "${STACK_ROOT}/opencode.local.json" "${HOME}/.config/opencode/opencode.local.json"
cp "${STACK_ROOT}/config/aider/.aider.conf.yml" "${HOME}/.aider.conf.yml"

echo "Bootstrap concluido."
echo "Agora leia docs/01-secrets-and-auth.md para concluir NVIDIA_API_KEY."
