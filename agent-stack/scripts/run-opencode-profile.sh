#!/usr/bin/env bash
set -euo pipefail

STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_NAME="${1:-}"
shift || true

NODE_BIN="${STACK_ROOT}/.state/node/node_modules/.bin"
VENV_BIN="${STACK_ROOT}/.state/venv/bin"
if [[ -d "${NODE_BIN}" ]]; then export PATH="${NODE_BIN}:${PATH}"; fi
if [[ -d "${VENV_BIN}" ]]; then export PATH="${VENV_BIN}:${PATH}"; fi

if [[ -z "${PROFILE_NAME}" ]]; then
  echo "Usage: ./scripts/run-opencode-profile.sh <fast|cheap|local-only|max-quality> [opencode args...]"
  exit 1
fi

PROFILES_JSON="${STACK_ROOT}/profiles.json"
CONFIG=$(python - <<'PY' "${PROFILES_JSON}" "${PROFILE_NAME}"
import json, sys
path, name = sys.argv[1], sys.argv[2]
data = json.load(open(path, "r", encoding="utf-8"))
if name not in data:
    print("")
    sys.exit(2)
print(data[name]["config"])
PY
)
MODEL=$(python - <<'PY' "${PROFILES_JSON}" "${PROFILE_NAME}"
import json, sys
path, name = sys.argv[1], sys.argv[2]
data = json.load(open(path, "r", encoding="utf-8"))
if name not in data:
    print("")
    sys.exit(2)
print(data[name]["model"])
PY
)
PROVIDER=$(python - <<'PY' "${PROFILES_JSON}" "${PROFILE_NAME}"
import json, sys
path, name = sys.argv[1], sys.argv[2]
data = json.load(open(path, "r", encoding="utf-8"))
if name not in data:
    print("")
    sys.exit(2)
print(data[name]["provider"])
PY
)

if [[ -z "${CONFIG}" || -z "${MODEL}" || -z "${PROVIDER}" ]]; then
  echo "Invalid profile: ${PROFILE_NAME}"
  exit 1
fi

export OPENCODE_CONFIG="${STACK_ROOT}/${CONFIG}"

if [[ "${PROVIDER}" == "nvidia" && -z "${NVIDIA_API_KEY:-}" ]]; then
  echo "NVIDIA_API_KEY is not set. See docs/01-secrets-and-auth.md"
  exit 1
fi

if [[ "${PROVIDER}" == "ollama-local" ]]; then
  export OLLAMA_API_BASE="${OLLAMA_API_BASE:-http://127.0.0.1:11434}"
  export OLLAMA_OPENCODE_BASE="${OLLAMA_OPENCODE_BASE:-http://127.0.0.1:11434/v1}"
fi

echo "OpenCode profile: ${PROFILE_NAME} -> ${MODEL}"
exec opencode --model "${MODEL}" "$@"
