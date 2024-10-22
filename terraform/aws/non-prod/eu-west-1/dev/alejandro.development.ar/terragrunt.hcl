terraform {
  source = "git::https://github.com/asajaroff/tofu-aws-modules.git//modules/cloudfront-s3-static-site"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  s3_bucket_versioning = false # TODO: fill in value
  region = "eu-west-1" # TODO: fill in value
  s3_origin_path = "/public"
  s3_bucket_name = "alejandro-sajaroff-website"
  subdomain = "alejandro"
  hosted_zone_domain_name = "development.ar"
  extra_tags = {"Environment":"Development","Terragrunt":"false"}
  # is_prod = false
}
