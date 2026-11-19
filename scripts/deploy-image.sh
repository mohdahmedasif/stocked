#!/usr/bin/env bash
# Pull the image that CI published for main, then restart the app with it.
# Run on the server after a green build-deploy workflow run:
#   bash scripts/deploy-image.sh
#
# The image is public on GHCR, or the server has run `docker login ghcr.io` once.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Pulling image"
docker compose pull stocked

echo "==> Restarting"
docker compose up -d stocked

# Remove the old image layers this pull replaced.
docker image prune -f >/dev/null

echo "==> Running $(docker inspect -f '{{.Config.Image}}' stocked-app) ($(docker inspect -f '{{.Image}}' stocked-app | cut -c8-19))"
