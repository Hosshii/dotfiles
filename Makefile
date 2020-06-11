DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))


.PHONY: init
init:
	@./etc/init/init.sh

.PHONY: deploy_fish
deploy-fish:
	@./etc/init/fish/deploy_fish.sh

.PHONY: deploy
deploy:
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)