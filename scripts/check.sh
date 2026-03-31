#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="${OPENCLAW_STATE_DIR:-$ROOT_DIR/.local/openclaw}"
ENV_FILE="$ROOT_DIR/.env"
REPO_ONLY=0

usage() {
  cat <<'EOF'
Usage: ./scripts/check.sh [--repo-only]

  --repo-only  Validate repository templates only.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --repo-only)
      REPO_ONLY=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

echo "Checking repository layout..."

test -f "$ROOT_DIR/AGENTS.md"
test -f "$ROOT_DIR/config/openclaw.json"
test -f "$ROOT_DIR/docs/agent-onboarding.md"
test -f "$ROOT_DIR/workspace/AGENTS.md"
test -f "$ROOT_DIR/workspace/TOOLS.md"
test -f "$ROOT_DIR/workspace/TOOLS-CONFIG.md"
test -f "$ROOT_DIR/workspace/MEMORY.md"
test -f "$ROOT_DIR/workspace/skills/read-write-workflow/SKILL.md"
test -f "$ROOT_DIR/workspace/skills/memory-read-write/SKILL.md"

if [ "$REPO_ONLY" -eq 1 ]; then
  echo "Repository checks passed."
  exit 0
fi

echo "Checking runtime state..."

if [ ! -d "$STATE_DIR" ] || [ ! -f "$STATE_DIR/openclaw.json" ] || [ ! -d "$STATE_DIR/workspace" ]; then
  echo "Runtime state missing under $STATE_DIR"
  echo "Run ./scripts/prepare-state.sh or ./scripts/bootstrap-docker.sh first, or use --repo-only."
  exit 1
fi

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
