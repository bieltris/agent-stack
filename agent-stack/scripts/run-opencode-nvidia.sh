#!/usr/bin/env bash
set -euo pipefail

STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export OPENCODE_CONFIG="${STACK_ROOT}/opencode.json"

if [[ -z "${NVIDIA_API_KEY:-}" ]]; then
  echo "NVIDIA_API_KEY nao esta definido. Veja docs/01-secrets-and-auth.md" 1>&2
  exit 1
fi

exec opencode --model nvidia/z-ai/glm5 "$@"
