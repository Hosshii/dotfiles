#!/usr/bin/env bash
set -euo pipefail

pin="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/source.json"
version_pattern='^[1-9][0-9]{0,3}(\.(0|[1-9][0-9]{0,3})){1,3}$'

download() {
  curl --disable --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
    --max-time 45 --max-filesize 1048576 --retry 2 "$1"
}

[[ -f "$pin" && ! -L "$pin" ]]
current=$(jq -er '.version' "$pin")
version=$(download https://product-details.mozilla.org/1.0/firefox_versions.json |
  jq -er '.LATEST_FIREFOX_VERSION')
if [[ ! "$current" =~ $version_pattern || ! "$version" =~ $version_pattern ]]; then
  printf 'Unexpected Firefox version: %s -> %s\n' "$current" "$version" >&2
  exit 1
fi

newer=$(jq -n --arg current "$current" --arg version "$version" '
  def parts: split(".") | map(tonumber) | (. + [0, 0, 0, 0])[:4];
  ($version | parts) > ($current | parts)
')
if [[ "$newer" != true ]]; then
  printf 'No update available for Firefox %s.\n' "$current"
  exit 0
fi

checksum=$(download "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/SHA256SUMS" |
  awk -v file="mac/ja-JP-mac/Firefox ${version}.dmg" 'substr($0, 67) == file { print $1 }')
if [[ ! "$checksum" =~ ^[0-9a-fA-F]{64}$ ]]; then
  printf 'Expected one SHA-256 entry for the Japanese macOS Firefox %s DMG.\n' "$version" >&2
  exit 1
fi
hash=$(printf '%s' "$checksum" | xxd -r -p | base64 | tr -d '\n')

next=$(mktemp "${pin}.XXXXXX")
trap 'rm -f -- "$next"' EXIT
jq -n --arg version "$version" --arg hash "sha256-$hash" '{version: $version, hash: $hash}' > "$next"
chmod 644 "$next"
mv -- "$next" "$pin"
printf 'Updated Firefox %s -> %s.\n' "$current" "$version"
