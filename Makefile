
.PHONY: all

make-dev:
	terragrunt run-all plan --terragrunt-working-dir ./terraform/aws/non-prod/eu-west-1/dev
