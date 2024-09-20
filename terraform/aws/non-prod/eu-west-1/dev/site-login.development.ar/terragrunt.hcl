
# This is a Terragrunt module generated by boilerplate.
terraform {
  source = "git::https://github.com/asajaroff/tf-aws-cloudfront-s3-origin.git//."
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}


inputs = {
  # --------------------------------------------------------------------------------------------------------------------
  # Required input variables
  # --------------------------------------------------------------------------------------------------------------------

  # Description: Enable versioning on the S3 bucket
  # Type: bool
  s3_bucket_versioning = false

  # Description: Region where the AWS provider will be configured and deployed
  # Type: string
  region = local.region_vars.locals.aws_region


  # --------------------------------------------------------------------------------------------------------------------
  # Optional input variables
  # Uncomment the ones you wish to set
  # --------------------------------------------------------------------------------------------------------------------

  # Description:
  #   None
  #   
  # Type: string
  s3_origin_path = "/public"

  # Description: Name of the S3 bucket that will be created to store the static site content
  # Type: string
  s3_bucket_name = ""

  # Description:
  #   Subdomain of the site.
  #   
  # Type: string
  subdomain = "login"

  # Description: Top level domain of the site, written with a trailing dot: "example.com."
  # Type: string
  hosted_zone_domain_name = local.environment_vars.locals.domain_name

  # Description: Extra tags to be added to the resources created by this module
  # Type: map
  # extra_tags = {"Environment":"Development","Terragrunt":"false"}

  # Description:
  #   If true, will enable Bucket Versioning and Bucket Logging.
  #   Two lines testing
  #   
  # Type: bool
  # is_prod = false

}
