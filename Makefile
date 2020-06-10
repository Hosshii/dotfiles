DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

init:
	@./bin/init.sh

deploy-fish:
	@./bin/deploy_fish.sh