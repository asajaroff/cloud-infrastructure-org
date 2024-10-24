CMD = $(shell which terragrunt)
CMD_OPTS = --terragrunt-parallelism 2 
LOG ?= error
LOG_LEVEL = --terragrunt-log-level $(LOG) --terragrunt-forward-tf-stdout

.PHONY: help
help: ## Prints this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo
	@echo make target LOG=info


dev: ## Runs `terragrunt run-all` for dev
	$(CMD) run-all plan \
		--terragrunt-working-dir ./terraform/aws/non-prod/eu-west-1/dev \
		$(CMD_OPTS) $(LOG_LEVEL)

prod: ## Runs `terragrunt run-all` for prod
	$(CMD) run-all plan \
		--terragrunt-working-dir ./terraform/aws/prod/eu-west-1 \
		$(CMD_OPTS) \
		$(LOG_LEVEL)

apply-prod: ## Runs `terragrunt run-all` for prod
	$(CMD) run-all apply \
		--terragrunt-working-dir ./terraform/aws/prod/eu-west-1 \
		$(CMD_OPTS) \
		$(LOG_LEVEL)
