#!/usr/bin/env bash
set -euo pipefail

STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Portable bootstrap: do not write to $HOME (some environments block it).
# Runner scripts set OPENCODE_CONFIG and aider config paths explicitly.

if [[ ! -f "${STACK_ROOT}/.env" ]]; then
  cp "${STACK_ROOT}/.env.example" "${STACK_ROOT}/.env"
  echo "Criado .env a partir de .env.example."
else
  echo ".env ja existe."
fi

echo "Bootstrap concluido (modo portatil, sem escrever no HOME)."
echo "Agora leia docs/01-secrets-and-auth.md para concluir NVIDIA_API_KEY."
