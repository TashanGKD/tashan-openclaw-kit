#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="${OPENCLAW_STATE_DIR:-$ROOT_DIR/.local/openclaw}"
ENV_FILE="$ROOT_DIR/.env"
TEMPLATE_ENV="$ROOT_DIR/.env.example"
TEMPLATE_CONFIG="$ROOT_DIR/config/openclaw.json"
TEMPLATE_WORKSPACE="$ROOT_DIR/workspace"

mkdir -p "$STATE_DIR" "$STATE_DIR/workspace" "$STATE_DIR/workspace/memory"

if [ ! -f "$ENV_FILE" ]; then
  cp "$TEMPLATE_ENV" "$ENV_FILE"
  echo "Created $ENV_FILE from template."
fi

if grep -Eq '^OPENCLAW_GATEWAY_TOKEN=change-me$' "$ENV_FILE"; then
  if command -v openssl >/dev/null 2>&1; then
    TOKEN="$(openssl rand -hex 32)"
  else
    TOKEN="$(date +%s | shasum | awk '{print $1}')"
  fi
  TMP_FILE="$(mktemp)"
  awk -v token="$TOKEN" '
    /^OPENCLAW_GATEWAY_TOKEN=change-me$/ { print "OPENCLAW_GATEWAY_TOKEN=" token; next }
    { print }
  ' "$ENV_FILE" > "$TMP_FILE"
  mv "$TMP_FILE" "$ENV_FILE"
  echo "Generated OPENCLAW_GATEWAY_TOKEN in $ENV_FILE."
fi

if [ ! -f "$STATE_DIR/openclaw.json" ]; then
  cp "$TEMPLATE_CONFIG" "$STATE_DIR/openclaw.json"
  echo "Copied default config to $STATE_DIR/openclaw.json"
fi

if command -v rsync >/dev/null 2>&1; then
  rsync -a --ignore-existing "$TEMPLATE_WORKSPACE"/ "$STATE_DIR/workspace"/
else
  cp -R -n "$TEMPLATE_WORKSPACE"/. "$STATE_DIR/workspace"/
fi

echo "State prepared at: $STATE_DIR"
echo "Config file: $STATE_DIR/openclaw.json"
echo "Workspace: $STATE_DIR/workspace"
