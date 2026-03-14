#!/usr/bin/env bash

if [ -z "$SANDBOX_ENV_PATH" ]; then
    # We are not in the nix develop environment or it wasn't reloaded
    echo "Reloading environment via nix develop..."
    exec nix develop --command "$0" "$@"
fi

PROJECT_DIR="$(pwd)/project"

exec bwrap \
  --ro-bind / / \
  --bind "$PROJECT_DIR" "$PROJECT_DIR" \
  --dev /dev \
  --proc /proc \
  --tmpfs /tmp \
  --unshare-all \
  --share-net \
  --setenv PATH "$SANDBOX_ENV_PATH/bin" \
  --setenv GEMINI_API_KEY "$GEMINI_API_KEY" \
  --setenv SSL_CERT_FILE "$SSL_CERT_FILE" \
  --setenv GEMINI_CLI_SYSTEM_SETTINGS_PATH "$GEMINI_CLI_SYSTEM_SETTINGS_PATH" \
  --setenv HOME "/tmp" \
  --chdir "$PROJECT_DIR" \
  "$SANDBOX_ENV_PATH/bin/gemini" "$@"