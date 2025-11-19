#!/bin/sh
set -eu

ENV_FILE="${ENV_FILE:-/godotapp/.env}"
ENV_KEYS="${ENV_KEYS:-DISCORD_BOT_TOKEN}"

# Always recreate the .env file so downstream code can rely on it.
: > "$ENV_FILE"

for key in $ENV_KEYS; do
    value="$(printenv "$key" 2>/dev/null || true)"
    if [ -n "$value" ]; then
        printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
    fi
done

exec "$@"
