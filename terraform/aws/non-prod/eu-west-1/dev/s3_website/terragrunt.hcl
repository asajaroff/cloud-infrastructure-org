# Include the root terragrunt.hcl config
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "/Users/alejandrosajaroff/Code/github.com/asajaroff/tf-aws-s3-website/modules/s3"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env              = local.environment_vars.locals.environment
  region           = local.region_vars.locals.aws_region
}


inputs = {
  name                = "website-s3-${local.environment_vars.locals.environment}"
  block_public_access = true
  region              = local.region
  force_destroy       = true
}
