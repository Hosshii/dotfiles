FROM mcr.microsoft.com/devcontainers/base:debian

USER root
RUN apt-get update && apt-get install -y --no-install-recommends locales \
  && sed -i 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=ja_JP.UTF-8
ENV LC_CTYPE=ja_JP.UTF-8
# LC_ALL は空のまま/未設定推奨（変な上書きを防ぐ）
ENV LC_ALL=

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
