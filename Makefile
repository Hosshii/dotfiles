DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

.PHONY: init
init:
	@./etc/init/init.sh

.PHONY: deploy_fish
deploy-fish:
	@./etc/init/fish/deploy_fish.sh