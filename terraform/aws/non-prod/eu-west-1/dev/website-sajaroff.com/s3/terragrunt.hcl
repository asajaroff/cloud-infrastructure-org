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
  common_vars      = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = {
  bucket_prefix       = "${local.environment_vars.locals.environment}-static-site-${local.common_vars.locals.site_name}-"
  block_public_access = true
  force_destroy       = true # change for prod

  region = local.region_vars.locals.aws_region
}
