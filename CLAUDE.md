# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository that manages configuration files for macOS and Linux (Arch Linux). It uses [rhysd/dotfiles](https://github.com/rhysd/dotfiles) tool to create symlinks from this repository to the appropriate locations.

## Installation

```bash
bash -c "$(curl -L https://raw.githubusercontent.com/Hosshii/dotfiles/master/install.sh)"
```

## Architecture

### Directory Structure

- `xdg/config/` - XDG config files, symlinked to `~/.config/`
- `xdg/data/` - XDG data files, symlinked to `~/.local/share/`
- `config/` - System configuration files (e.g., Xorg configs for Linux)
- `script/` - Platform-specific initialization scripts
- `.dotfiles/` - Symlink mapping definitions (JSON files)

### Symlink Mappings

Mappings are defined in `.dotfiles/mappings_*.json`:
- `mappings_unixlike.json` - Common mappings for macOS/Linux (`xdg/config` → `~/.config`, `xdg/data` → `~/.local/share`)
- `mappings_linux.json` - Linux-specific mappings (e.g., Xorg keyboard config)

### Platform-Specific Scripts

- `script/brew/` - macOS (Homebrew setup, Brewfile)
- `script/pacman/` - Arch Linux (pacman/paru packages)
- `script/manual/` - Cross-platform manual setup (rustup)
- `script/default_write/` - macOS system preferences

## Post-Installation Manual Changes

After installation, manually configure in `xdg/config/git/config`:
- `name` - Git user name
- `email` - Git email address
