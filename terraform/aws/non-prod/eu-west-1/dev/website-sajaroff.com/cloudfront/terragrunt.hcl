# Include the root terragrunt.hcl config
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "/Users/alejandrosajaroff/Code/github.com/asajaroff/tofu-aws-modules/modules/cdn"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  module_vars      = read_terragrunt_config(find_in_parent_folders("module_vars.hcl"))

  # Submodule specific-locals
  site_name = "${local.module_vars.locals.site_name}"
  site_fqdn = "${local.module_vars.locals.site_name}.${local.region_vars.locals.domain_name_website_svelte}"
}

dependency "s3" {
  config_path                             = "../s3"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh"]
  mock_outputs = {
    bucket_id = "mocked_s3_bucket_id"
  }
}

dependency "acm" {
  config_path                             = "../acm"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh"]
  mock_outputs = {
    acm_website_arn = "arn:aws:acm:us-east-1:123456789012:certificate/d47c644c-be03-4910-9171-8d9974db8620"
  }
}

inputs = {
  top_level_domain_name          = "${local.module_vars.locals.top_level_domain_name}"
  domain_name                    = "${local.module_vars.locals.site_name}"
  description                    = "${local.site_fqdn} static website"
  aws_acm_certificate_arn        = dependency.acm.outputs.acm_website_arn
  aliases                        = ["${dependency.acm.outputs.acm_website_domain_name}", "www.${dependency.acm.outputs.acm_website_domain_name}"]
  s3_bucket_id                   = dependency.s3.outputs.bucket_id
  s3_bucket_regional_domain_name = dependency.s3.outputs.bucket_regional_domain_name
  s3_origin_path                 = "/public"
  region                         = local.region_vars.locals.aws_region
  environment                    = local.environment_vars.locals.environment
}
