#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${OPENCLAW_LOCAL_HOME:-$HOME/.openclaw}"
FORCE=0
FORCE_ENV=0

usage() {
  cat <<'EOF'
Usage: ./scripts/bootstrap-local.sh [--force] [--force-env]

  --force      Refresh local openclaw.json and workspace files from this template.
               Existing extra files are kept.
  --force-env  Also replace the local .env from .env.example.
               Use with care if your local .env already contains real secrets.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --force)
      FORCE=1
      ;;
    --force-env)
      FORCE=1
      FORCE_ENV=1
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

mkdir -p "$TARGET_DIR" "$TARGET_DIR/workspace" "$TARGET_DIR/workspace/memory"

if [ "$FORCE" -eq 1 ] || [ ! -f "$TARGET_DIR/openclaw.json" ]; then
  cp "$ROOT_DIR/config/openclaw.json" "$TARGET_DIR/openclaw.json"
  echo "Copied config to $TARGET_DIR/openclaw.json"
else
  echo "Skipped existing $TARGET_DIR/openclaw.json"
fi

if [ "$FORCE_ENV" -eq 1 ] || [ ! -f "$TARGET_DIR/.env" ]; then
  cp "$ROOT_DIR/.env.example" "$TARGET_DIR/.env"
  echo "Copied env template to $TARGET_DIR/.env"
else
  echo "Skipped existing $TARGET_DIR/.env"
fi

if command -v rsync >/dev/null 2>&1; then
  if [ "$FORCE" -eq 1 ]; then
    rsync -a "$ROOT_DIR/workspace"/ "$TARGET_DIR/workspace"/
    echo "Refreshed workspace files in $TARGET_DIR/workspace"
  else
    rsync -a --ignore-existing "$ROOT_DIR/workspace"/ "$TARGET_DIR/workspace"/
    echo "Synced missing workspace files to $TARGET_DIR/workspace"
  fi
else
  if [ "$FORCE" -eq 1 ]; then
    cp -R "$ROOT_DIR/workspace"/. "$TARGET_DIR/workspace"/
    echo "Refreshed workspace files in $TARGET_DIR/workspace"
  else
    cp -R -n "$ROOT_DIR/workspace"/. "$TARGET_DIR/workspace"/
    echo "Synced missing workspace files to $TARGET_DIR/workspace"
  fi
fi

echo "Local OpenClaw template synced to $TARGET_DIR"
echo "Use --force after this template changes and you want local defaults updated."
echo "If you use OpenClaw.app or a host install, fill $TARGET_DIR/.env and start the gateway normally."
