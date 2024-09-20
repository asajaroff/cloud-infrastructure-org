# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "dev"
  domain_name = "development.ar"

  s3_unique_identifier = "asajaroff-${local.environment}"
  s3_bucket_versioning = false
}
