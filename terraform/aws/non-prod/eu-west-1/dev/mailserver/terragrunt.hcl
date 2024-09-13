# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  suffix           = "${local.environment_vars.locals.environment}-${local.region_vars.locals.aws_region}"
}

dependency "network" {
  config_path                             = "../network"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    vpc_id         = "vpc-${local.suffix}"
    public_subnets = ["i-123457890"]
    sg_allow_ssh   = ["sg-acbd1234"]
  }
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/ec2-instance/aws?version=5.7.0"
}

inputs = {
  name          = "appserver-generic-${local.suffix}"
  ami           = "ami-03b9edf83c8d896e6"
  instance_type = "t3.micro" // ToDo consider ARM
  key_name      = "mailserver-test"

  associate_public_ip_address = true
  subnet_id                   = dependency.network.outputs.public_subnets
  vpc_security_group_ids      = dependency.network.outputs.sg_allow_ssh
}