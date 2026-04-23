#!/usr/bin/env bash
set -euo pipefail

STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMAND="${1:-help}"
TARGET="${2:-}"

show_help() {
  cat <<'EOF'
Agent Stack Command Center

Usage:
  stack help
  stack profiles
  stack run <fast|cheap|local-only|max-quality> [opencode args...]
  stack aider [aider args...]
  stack doctor
  stack status
  stack opencode-nvidia [opencode args...]
  stack opencode-local [opencode args...]
  stack bootstrap
EOF
}

show_profiles() {
  python - <<'PY' "${STACK_ROOT}/profiles.json"
import json, sys
data = json.load(open(sys.argv[1], "r", encoding="utf-8"))
for name, profile in data.items():
    print(f"{name:12} {profile['provider']:14} {profile['model']}")
PY
}

show_status() {
  echo "opencode_installed=$([[ -x "$(command -v opencode || true)" ]] && echo true || echo false)"
  echo "aider_installed=$([[ -x "$(command -v aider || true)" ]] && echo true || echo false)"
  echo "docker_installed=$([[ -x "$(command -v docker || true)" ]] && echo true || echo false)"
  echo "ollama_installed=$([[ -x "$(command -v ollama || true)" ]] && echo true || echo false)"
  echo "nvidia_key_in_session=$([[ -n "${NVIDIA_API_KEY:-}" ]] && echo true || echo false)"
  echo "ollama_api_base=${OLLAMA_API_BASE:-unset}"
}

case "${COMMAND}" in
  help) show_help ;;
  profiles) show_profiles ;;
  run)
    if [[ -z "${TARGET}" ]]; then
      echo "Missing profile name"
      exit 1
    fi
    shift 2
    exec "${STACK_ROOT}/scripts/run-opencode-profile.sh" "${TARGET}" "$@"
    ;;
  aider)
    shift
    exec "${STACK_ROOT}/scripts/run-aider.sh" "$@"
    ;;
  doctor)
    exec "${STACK_ROOT}/scripts/doctor.sh"
    ;;
  status)
    show_status
    ;;
  opencode-nvidia)
    shift
    exec "${STACK_ROOT}/scripts/run-opencode-nvidia.sh" "$@"
    ;;
  opencode-local)
    shift
    exec "${STACK_ROOT}/scripts/run-opencode-local.sh" "$@"
    ;;
  bootstrap)
    exec "${STACK_ROOT}/scripts/bootstrap.sh"
    ;;
  *)
    echo "Unknown command: ${COMMAND}"
    show_help
    exit 1
    ;;
esac
