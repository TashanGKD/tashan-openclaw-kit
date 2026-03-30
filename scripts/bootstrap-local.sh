#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${OPENCLAW_LOCAL_HOME:-$HOME/.openclaw}"

mkdir -p "$TARGET_DIR" "$TARGET_DIR/workspace" "$TARGET_DIR/workspace/memory"

if [ ! -f "$TARGET_DIR/openclaw.json" ]; then
  cp "$ROOT_DIR/config/openclaw.json" "$TARGET_DIR/openclaw.json"
  echo "Copied config to $TARGET_DIR/openclaw.json"
else
  echo "Skipped existing $TARGET_DIR/openclaw.json"
fi

if [ ! -f "$TARGET_DIR/.env" ]; then
  cp "$ROOT_DIR/.env.example" "$TARGET_DIR/.env"
  echo "Copied env template to $TARGET_DIR/.env"
else
  echo "Skipped existing $TARGET_DIR/.env"
fi

if command -v rsync >/dev/null 2>&1; then
  rsync -a --ignore-existing "$ROOT_DIR/workspace"/ "$TARGET_DIR/workspace"/
else
  cp -R -n "$ROOT_DIR/workspace"/. "$TARGET_DIR/workspace"/
fi

echo "Local OpenClaw template synced to $TARGET_DIR"
echo "If you use OpenClaw.app or a host install, fill $TARGET_DIR/.env and start the gateway normally."
