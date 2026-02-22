FROM mcr.microsoft.com/devcontainers/base:debian

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nix \
    && printf '%s\n' 'experimental-features = nix-command flakes' > /etc/nix/nix.conf

USER vscode

RUN sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon

ENV PATH=/home/vscode/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}

RUN nix --version
