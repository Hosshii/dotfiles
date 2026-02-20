#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCES_FILE="$SCRIPT_DIR/sources.json"
ADDON_SLUG="1password-x-password-manager"
API_URL="https://addons.mozilla.org/api/v5/addons/addon/$ADDON_SLUG/"

echo "Fetching latest 1Password Firefox addon metadata..."
addon_info="$(curl -fsSL "$API_URL")"

addon_id="$(echo "$addon_info" | jq -er '.guid')"
version="$(echo "$addon_info" | jq -er '.current_version.version')"
url="$(echo "$addon_info" | jq -er '.current_version.file.url')"
current_version="$(jq -er '.version' "$SOURCES_FILE")"

echo "Current version: $current_version"
echo "Latest version:  $version"

if [ "$version" = "$current_version" ]; then
  echo "Already up to date. No changes made."
  exit 0
fi

echo "Prefetching XPI hash..."
prefetch_result="$(nix store prefetch-file --json "$url")"
sha256="$(echo "$prefetch_result" | jq -er '.hash')"

echo "Updating $SOURCES_FILE..."
jq -n \
  --arg addonId "$addon_id" \
  --arg version "$version" \
  --arg url "$url" \
  --arg sha256 "$sha256" \
  '{addonId: $addonId, version: $version, url: $url, sha256: $sha256}' \
  > "$SOURCES_FILE"

echo "Done. Updated to version $version"
