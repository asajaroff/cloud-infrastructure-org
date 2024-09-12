locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
  # common_vars  = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  # region       = local.common_vars.region
  # environment  = local.common_vars.environment

  # A debug line
  # debug_line = run_cmd("echo", "${jsonencode(local.environment_vars)}")

  default_tags = {
    terragrunt  = true
    environment = local.environment_vars.locals.environment
  }

  # Load an overrides.yml file in any Terragrunt folder, or fallback to {} if none is found
  overrides = try(yamldecode(file("${get_terragrunt_dir()}/overrides.yml")), {})

  # Read the override tags, if any, from overrides.yml, or fallback to {} if none are found
  override_tags = lookup(local.overrides, "tags", {})

  # The final tags to apply to all resources are a merge between the default tags and override tags
  tags = merge(local.default_tags, local.override_tags)
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = ${jsonencode(local.tags)}
  }

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

terraform {
  before_hook "format_hcl" {
    commands = ["plan"]
    execute  = ["terragrunt", "hclfmt", ]
  }

  before_hook "format_tf" {
    commands = ["plan"]
    execute  = ["terraform", "fmt", ]
  }

  # ToDo: execute infracost after plan and apply
  #  after_hook "infracost" {
  #    commands     = ["plan", "apply", "refresh"]
  #    execute      = ["infracost", "breakdown", "--path", "."]
  #    run_on_error = false
  #  }

}


# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${get_env("TG_BUCKET_PREFIX", "")}terragrunt-tf-state-${local.account_name}-${local.aws_region}"
    key            = "${path_relative_to_include()}/tf.tfstate"
    region         = local.aws_region
    dynamodb_table = "tf-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
