#!/usr/bin/env bash
# Download the newest build from GitHub Releases and switch the app to it.
# Run on the server as the app user:
#   bash scripts/update-release.sh
#
# Layout (created on first run):
#   /srv/stocked/releases/<commit>/server   one folder per build
#   /srv/stocked/current                    symlink to the build that is running
#   /srv/stocked/data                       database and secret.key (kept across builds)
#   /srv/stocked/.env                       ADMIN_KEY and other settings
set -euo pipefail

APP_DIR="${APP_DIR:-/srv/stocked}"
REPO="${REPO:-mohdahmedasif/stocked}"
KEEP="${KEEP:-3}"
URL="https://github.com/${REPO}/releases/latest/download/stocked.tar.gz"

mkdir -p "$APP_DIR/releases" "$APP_DIR/data"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "==> Downloading the latest build"
curl -fsSL "$URL" -o "$TMP/stocked.tar.gz"
tar -xzf "$TMP/stocked.tar.gz" -C "$TMP"

COMMIT="$(cut -c1-7 "$TMP/server/BUILD")"
DEST="$APP_DIR/releases/$COMMIT"

if [ -d "$DEST" ]; then
  echo "Build $COMMIT is already installed; nothing to do."
  exit 0
fi

echo "==> Installing build $COMMIT"
mv "$TMP/server" "$DEST"

# Switch the link in one step, so the service never sees a half-updated folder.
ln -sfn "$DEST" "$APP_DIR/current.new"
mv -T "$APP_DIR/current.new" "$APP_DIR/current"

echo "==> Restarting"
sudo systemctl restart inventory

PORT="$(grep -E '^PORT=' "$APP_DIR/.env" 2>/dev/null | cut -d= -f2 || true)"
sleep 3
if curl -fsS "http://127.0.0.1:${PORT:-3000}/api/health" >/dev/null; then
  echo "==> Running build $COMMIT"
else
  echo "Health check failed. Check: sudo journalctl -u inventory -n 50" >&2
  exit 1
fi

echo "==> Removing old builds (keeping $KEEP)"
ls -1dt "$APP_DIR"/releases/*/ | tail -n +"$((KEEP + 1))" | xargs -r rm -rf
