#!/usr/bin/env bash
set -euo pipefail

export OPENCODE_CONFIG="${OPENCODE_CONFIG:-/stack/opencode.json}"
export OLLAMA_API_BASE="${OLLAMA_API_BASE:-http://host.docker.internal:11434}"
export OLLAMA_OPENCODE_BASE="${OLLAMA_OPENCODE_BASE:-http://host.docker.internal:11434/v1}"

mkdir -p /root/.config/opencode
cp /stack/opencode.json /root/.config/opencode/opencode.json
cp /stack/opencode.local.json /root/.config/opencode/opencode.local.json
cp /stack/config/aider/.aider.conf.yml /root/.aider.conf.yml

exec "$@"
