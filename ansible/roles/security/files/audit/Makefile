#!/usr/bin/make -f

.PHONY: help
.DEFAULT_GOAL := help
SHELL ?= /bin/sh

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

update: ## Update the rulesets
	@rm -Rf *.rules
	@rm -Rf audit-*
	@git clone https://github.com/linux-audit/audit-userspace.git
	@cp audit-userspace/rules/10-base-config.rules ./
	@cp audit-userspace/rules/11-loginuid.rules ./
	@cp audit-userspace/rules/12-cont-fail.rules ./
	@cp audit-userspace/rules/21-no32bit.rules ./
	@cp audit-userspace/rules/22-ignore-chrony.rules ./
	@cp audit-userspace/rules/23-ignore-filesystems.rules ./
	@cp audit-userspace/rules/30-nispom.rules ./
	@cp audit-userspace/rules/32-power-abuse.rules ./
	@cp audit-userspace/rules/40-local.rules ./
	@cp audit-userspace/rules/41-containers.rules ./
	@cp audit-userspace/rules/42-injection.rules ./
	@cp audit-userspace/rules/43-module-load.rules ./
	@cp audit-userspace/rules/99-finalize.rules ./
	@rm -Rf audit-*
	@echo "Audit files have been updated from GIT."
	@echo "https://github.com/linux-audit/audit-userspace.git"