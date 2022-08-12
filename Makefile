.PHONY: help
.DEFAULT_GOAL := help
SHELL ?= /usr/bin/zsh

COLOR_GREEN=$(shell echo "\033[0;32m")
COLOR_RED=$(shell echo "\033[0;31m")
COLOR_END=$(shell echo "\033[0;0m")

DEPLOYMENT := $(shell grep deployment_name terraform.tfvars | awk -F'=' {'print $$2'} | tr -d \" | tr -d \ )
BUFFER_ITERATIONS = 6
BUFFER_SLEEP = 10

## ---
## HELP - SHOWS A LIST OF AVAILABLE TARGETS WHICH CAN BE CALLED WITH MAKE.
## ---

help:
	@for makefile in $(MAKEFILE_LIST) ; do \
		grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $$makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' ; \
	done

## ---
## A LIST OF STAGES TO OPERATE IN ORDER. NOT SHOWN IN MAKE LIST.
## ---

terraform-deploy: ## Run the Terraform commands to deploy the virtual machine infrastructure.
	@echo "$(COLOR_GREEN)\n--- Deploying infrastructure using Terraform.$(COLOR_END)"
	- @terraform workspace new $(DEPLOYMENT)
	- @terraform workspace select $(DEPLOYMENT)
	@terraform init && terraform validate && terraform plan && terraform apply -auto-approve

ansible-deploy: ## Run the Ansible playbook against the K8s infrastructure.
	@echo "$(COLOR_GREEN)\n--- Running Ansible Playbook.$(COLOR_END)"
	@cd ansible && ansible-playbook -i inventory/$(DEPLOYMENT)/$(DEPLOYMENT)-inventory main.yml

links: ## print links to screen
	@ansible/files/$(DEPLOYMENT)/minio-ui-links.sh

terraform-teardown: ## Run the Terraform commands to destroy the K8s infrastructure. WARNING: Permanent deletion!
	@echo "$(COLOR_GREEN)\n--- Tearing down infrastructure deployed by Terraform.$(COLOR_END)"
	@echo -n "$(COLOR_RED)\n--- Are you sure? This will destroy ALL RESOURCES in '$(DEPLOYMENT)'. If you are sure, type '$(DEPLOYMENT)'. $(COLOR_END)" && read ans && [ $${ans:-N} = $(DEPLOYMENT) ]
	@terraform workspace select $(DEPLOYMENT) && terraform destroy -auto-approve

pause-buffer:
	@echo "$(COLOR_GREEN)\n--- Waiting $(BUFFER_ITERATIONS)0s to allow the backend infrastructure to process any unfinished work.\nPlease wait.$(COLOR_END)"

	@n=$(BUFFER_ITERATIONS); \
	while [ $${n} -gt 0 ]; do\
		echo $$n"0"; \
		n=`expr $$n - 1`; \
		sleep $(BUFFER_SLEEP); \
	done; \
	true

	@echo "$(COLOR_GREEN)\n--- Pause Buffer Complete.  Continuing.$(COLOR_END)"

## --
## CALL MULTIPLE TARGETS FROM A SINGLE CALL
## ---

setup: terraform-deploy pause-buffer ansible-deploy links ## Runs a full, end-to-end deployment with infrastructure, K8s, and umbrella.
	@echo "$(COLOR_GREEN)\n--- Setup completed.$(COLOR_END)"

teardown: terraform-teardown ## Runs all cleanup and teardown commands. WARNING: Permanent deletion!
	@echo "$(COLOR_GREEN)\n--- Teardown completed.$(COLOR_END)"

environment: docker-pull docker-up docker-shell ## Brings up a development environment with all required dependencies.