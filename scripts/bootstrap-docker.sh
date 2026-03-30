#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required but not installed."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose v2 is required but not available."
  exit 1
fi

"$ROOT_DIR/scripts/prepare-state.sh"

cd "$ROOT_DIR"
docker compose pull
docker compose up -d openclaw-gateway

PORT="${OPENCLAW_GATEWAY_PORT:-18789}"

echo
echo "OpenClaw Gateway is starting."
echo "Dashboard: http://127.0.0.1:${PORT}/"
echo "Logs: make logs"
echo "Dashboard token URL: make dashboard"
echo "Health check: make health"

if ! grep -Eq '^(OPENAI_API_KEY|ANTHROPIC_API_KEY|GEMINI_API_KEY)=.+' "$ROOT_DIR/.env"; then
  echo
  echo "No model provider key is set yet."
  echo "Edit .env, fill at least one of OPENAI_API_KEY / ANTHROPIC_API_KEY / GEMINI_API_KEY, then rerun:"
  echo "docker compose up -d openclaw-gateway"
fi
