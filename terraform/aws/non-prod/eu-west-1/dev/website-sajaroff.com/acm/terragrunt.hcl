# Include the root terragrunt.hcl config
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "/Users/alejandrosajaroff/Code/github.com/asajaroff/tf-aws-s3-website/modules/certificates"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  common_vars      = read_terragrunt_config(find_in_parent_folders("module_vars.hcl"))
}

inputs = {
  domain_name           = "dev-alejandro"
  top_level_domain_name = "${local.common_vars.locals.site_name}"
}
