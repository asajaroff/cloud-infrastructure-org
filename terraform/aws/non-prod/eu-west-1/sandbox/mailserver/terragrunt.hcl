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
  config_path = "../network"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    vpc_id         = "vpc-123456"
    public_subnets = ["i-123457890"]
    sg_allow_ssh   = "sg-1234567890abcd"
  }
  # skip_outputs = true
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/ec2-instance/aws?version=5.7.0"
}

# Fill in the variables for that module
inputs = {
  name = "mailserver-${local.environment_vars.locals.environment}-${local.region_vars.locals.region}1"
  ami  = "ami-03b9edf83c8d896e6"

  associate_public_ip_address = true

  instance_type          = "t3.micro" // ToDo consider ARM
  subnet_id              = dependency.network.outputs.public_subnets
  key_name               = "mailserver-test"
  vpc_security_group_ids = dependency.network.outputs.sg_allow_ssh
}
