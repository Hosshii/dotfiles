DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
BINFILES   := $(wildcard bin/*)


.PHONY: deploy_fish
deploy-fish:
	@./etc/init/fish/deploy_fish.sh

.PHONY: install_zinit
install_zinit:
	@./etc/init/zsh/init.sh

.PHONY: brew
brew:
	@echo '==> Start to install homebrew formula.'
	@echo ''
	@./etc/init/brew/init.sh

.PHONY: brew_light
brew_short:
	@echo '==> Start to install homebrew formula in light mode.'
	@echo ''
	@./etc/init/brew/init.sh -s

.PHONY: setup_vim
setup_vim: 
	@echo '==> Setup vim'
	@echo ''
	@./etc/init/vim/init.sh

.PHONY: setup_mac_default
setup_mac_default:
	@echo '==> Setup mac default write'
	@echo ''
	@./etc/init/default_write/init.sh

.PHONY: pacman
pacman:
	@echo '==> Start to install pacman package.'
	@echo ''
	@./etc/init/pacman/init.sh