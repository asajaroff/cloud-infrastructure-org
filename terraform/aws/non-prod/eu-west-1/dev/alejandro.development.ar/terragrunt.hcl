terraform {
  source = "git::https://github.com/asajaroff/tofu-aws-modules.git//modules/cloudfront-s3-static-site?ref=feat/pretty-urls"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  s3_bucket_versioning = false
  region = "eu-west-1"
  s3_origin_path = "/public"
  s3_bucket_name = "alejandro.development.ar-website"
  subdomain = "alejandro"
  hosted_zone_domain_name = "development.ar"
  extra_tags = {"Environment":"Development","Terragrunt":"true"}
  # is_prod = false
}
