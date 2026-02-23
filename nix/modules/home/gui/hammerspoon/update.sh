#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCES_FILE="$SCRIPT_DIR/sources.json"

echo "Fetching latest Hammerspoon release..."
RELEASE_INFO=$(curl -s "https://api.github.com/repos/Hammerspoon/hammerspoon/releases/latest")

VERSION=$(echo "$RELEASE_INFO" | jq -r '.tag_name')
URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | endswith(".zip") and (endswith(".sha256") | not)) | .browser_download_url')

echo "Latest version: $VERSION"
echo "Download URL: $URL"

# fetchzip と同じハッシュを取得するため、意図的に失敗させてハッシュを抽出
echo "Calculating sha256 using fetchzip..."
BUILD_OUTPUT=$(nix build --impure --no-link --expr "
  with import <nixpkgs> {};
  fetchzip {
    url = \"$URL\";
    hash = lib.fakeHash;
    stripRoot = false;
  }
" 2>&1 || true)

# macOS 互換: sed を使用してハッシュを抽出
SRI_HASH=$(echo "$BUILD_OUTPUT" | sed -n 's/.*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*/\1/p')

if [ -z "$SRI_HASH" ]; then
  echo "Error: Failed to extract hash from nix build output"
  echo "$BUILD_OUTPUT"
  exit 1
fi

echo "SHA256 (SRI): $SRI_HASH"

echo "Updating $SOURCES_FILE..."
cat > "$SOURCES_FILE" << EOF
{
  "version": "$VERSION",
  "url": "$URL",
  "sha256": "$SRI_HASH"
}
EOF

echo "Done! Updated to version $VERSION"
