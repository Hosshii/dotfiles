DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
BINFILES   := $(wildcard bin/*)


.PHONY: init
init:
	@./etc/init/init.sh

.PHONY: deploy_fish
deploy-fish:
	@./etc/init/fish/deploy_fish.sh

.PHONY: install_zinit
install_zinit:
	@./etc/init/zsh/init.sh

.PHONY: deploy
deploy:
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(BINFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val); )

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
setup_vim: deploy
	@echo '==> Setup vim'
	@echo ''
	@./etc/init/vim/init.sh

.PHONY: setup_mac_default
setup_mac_default:
	@echo '==> Setup mac default write'
	@echo ''
	@./etc/init/default_write/init.sh