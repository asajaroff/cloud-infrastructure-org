# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

dependency "network" {
  config_path                             = "../network"
  }

terraform {
  source = "/Users/alejandrosajaroff/Code/github.com/asajaroff/tofu-aws-modules/modules/ec2"

  after_hook "after_hook" {
    commands     = ["rm"]
    execute      = ["~/.ssh/id"]
    run_on_error = false
  }

  after_hook "after_hook" {
    commands     = ["apply"]
    execute      = ["terragrunt", "output -raw private_key > ~/.ssh/id"]
    run_on_error = false
  }

  after_hook "after_hook" {
    commands     = ["chmod"]
    execute      = ["400 ~/.ssh/id"]
    run_on_error = false
  }
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  subnet_id                   = dependency.network.outputs.public_subnets
  region = local.region_vars.locals.aws_region
}