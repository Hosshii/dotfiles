FROM mcr.microsoft.com/devcontainers/base:debian

ENV USER=vscode
ENV HOME=/home/vscode

USER vscode

# nix.conf 作成
RUN mkdir -p $HOME/.config/nix && \
    cat > $HOME/.config/nix/nix.conf <<'EOF'
experimental-features = nix-command flakes
always-allow-substitutes = true
auto-optimise-store = true
max-jobs = auto
EOF

RUN curl -fsSL https://nixos.org/nix/install | sh -s -- --no-daemon
# rootじゃないと無理なので以下は使わない
# RUN curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install linux \
#   --extra-conf "sandbox = false" --init none --no-confirm

ENV PATH=${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}

RUN nix --version
