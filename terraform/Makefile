.PHONY: all

CMD := terragrunt
TERRAGRUNT_PARAMS := "

create-dev:
	cd aws/non-prod/eu-west-1/dev/
	terragrunt run-all init 
	terragrunt run-all plan 

tf-fmt:
	terragrunt hclfmt \
		--terragrunt-diff \
		--terragrunt-no-colorfmt
terragrunt scaffold https://github.com/asajaroff/tf-aws-cloudfront-s3-origin/.
