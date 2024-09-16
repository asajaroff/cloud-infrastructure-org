# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "prod"
  aws_account_id = "761399334120"
  top_level_domain_names = {
    development = "sajaroff.com"
  }
}