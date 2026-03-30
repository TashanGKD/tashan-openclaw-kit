#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="${OPENCLAW_STATE_DIR:-$ROOT_DIR/.local/openclaw}"
ENV_FILE="$ROOT_DIR/.env"

echo "Checking repository layout..."

test -f "$ROOT_DIR/config/openclaw.json"
test -f "$ROOT_DIR/workspace/AGENTS.md"
test -f "$ROOT_DIR/workspace/TOOLS.md"
test -f "$ROOT_DIR/workspace/MEMORY.md"
test -f "$ROOT_DIR/workspace/skills/read-write-workflow/SKILL.md"
test -f "$ROOT_DIR/workspace/skills/memory-read-write/SKILL.md"

echo "Checking runtime state..."
test -d "$STATE_DIR"
test -f "$STATE_DIR/openclaw.json"
test -d "$STATE_DIR/workspace"

if [ -f "$ENV_FILE" ]; then
  echo "Found .env"
else
  echo "Missing .env"
  exit 1
fi

if command -v docker >/dev/null 2>&1; then
  docker compose -f "$ROOT_DIR/docker-compose.yml" config >/dev/null
  echo "docker compose config: ok"
else
  echo "Docker not installed; skipped compose validation."
fi

echo "All checks passed."
