terraform {
  source = "git::https://github.com/asajaroff/tofu-aws-modules.git//modules/cloudfront-s3-static-site?ref=feat/pretty-urls"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}
include "root" {
  path = find_in_parent_folders()
}

inputs = {
  s3_bucket_versioning = true
  region = local.region_vars.locals.aws_region
  s3_origin_path = "/public"
  s3_bucket_name = "alejandro.sajaroff.com-website"
  subdomain = "alejandro"
  hosted_zone_domain_name = local.account_vars.locals.top_level_domain_names.personal_website
  extra_tags = {"Environment":"prod","Terragrunt":"true"}
  is_prod = true
}
