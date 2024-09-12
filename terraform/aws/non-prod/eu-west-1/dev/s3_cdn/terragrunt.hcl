# Include the root terragrunt.hcl config
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "/Users/alejandrosajaroff/Code/github.com/asajaroff/tf-aws-s3-website/modules/cdn"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  debug_line = run_cmd("echo", "${jsonencode(local.environment_vars)}")
}

dependency "s3_website" {
  config_path = "../s3_website"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    cdn_name                       = "example.com"
    cdn_comment                    = "CDN for example.com"
    s3_bucket_id                   = ""
    s3_bucket_regional_domain_name = ""
  }
}

inputs = {
  cdn_name                       = "alejandro.sajaroff.com"
  cdn_comment                    = "Static assets only."
  s3_bucket_id                   = dependency.s3_website.outputs.s3_bucket_id
  s3_bucket_regional_domain_name = dependency.s3_website.outputs.s3_bucket_regional_domain_name
  region                         = local.region_vars.locals.aws_region
}
