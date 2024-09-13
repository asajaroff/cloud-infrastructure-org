# Include the root terragrunt.hcl config
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "/Users/alejandrosajaroff/Code/github.com/asajaroff/tf-aws-s3-website/modules/cdn"
}

locals {
  website_name     = "svelte-profile"

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  suffix           = "${local.environment_vars.locals.environment}"
  name_with_environment = "${local.website_name}-${local.suffix}"
  website_fqdn     = "${local.website_name}.${local.region_vars.locals.domain_name_website_svelte}"
}

dependency "s3_website" {
  config_path                             = "../s3_website"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    cdn_name                       = "example.com"
    cdn_comment                    = "example.com"
    s3_bucket_id                   = "mocked-s3_bucket_id-name"
    s3_bucket_regional_domain_name = "Mocked comment for regional domain name"
  }
}

dependency "certs" {
  config_path                             = "../s3_website_certs"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    acm_website_arn                       = "arn:aws:acm:eu-west-1:761399334120:certificate/d47c644c-cea9-4910-9171-8d9974db8620"
  }
}


inputs = {
  domain_name 			    = "${local.website_fqdn}"
  top_level_domain_name 	    = "${local.region_vars.locals.domain_name_website_svelte}"
  cdn_name		 	    = "${local.website_fqdn} for ${local.environment_vars.locals.environment}"
  cdn_comment		 	    = "${local.website_fqdn} for ${local.environment_vars.locals.environment}"
  aliases                           = "${dependency.certs.outputs.acm_website_domain_name}"
  aws_acm_certificate_arn	= dependency.certs.outputs.acm_website_arn
  s3_bucket_id                      = dependency.s3_website.outputs.s3_bucket_id
  s3_origin_path                    = "/build"
  s3_bucket_regional_domain_name    = dependency.s3_website.outputs.s3_bucket_regional_domain_name
  region                            = local.region_vars.locals.aws_region
  cdn_origin_access_control_name    = "${local.website_fqdn} ${local.suffix} origin access control"
  cdn_origin_access_control_comment = "${local.environment_vars.locals.environment}"
}
