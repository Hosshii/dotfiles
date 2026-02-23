#!/usr/bin/env bash

set -euo pipefail

DOTFILES_FLAKE="github:Hosshii/dotfiles?dir=nix"

arch="$(uname -m)"
case "${arch}" in
  x86_64)
    home_target="vscode@devcontainer-x86_64"
    ;;
  aarch64 | arm64)
    home_target="vscode@devcontainer-aarch64"
    ;;
  *)
    echo "Unsupported architecture: ${arch}" >&2
    echo "Supported architectures: x86_64, aarch64, arm64" >&2
    exit 1
    ;;
esac

echo "Nix version:"
nix --version

echo "Applying Home Manager config: ${home_target}"
nix run github:nix-community/home-manager -- switch --flake "${DOTFILES_FLAKE}#${home_target}"

echo "Home Manager config applied successfully."
