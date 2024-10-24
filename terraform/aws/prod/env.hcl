# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.

# Add the following line to import these variables
# environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

# Once imported, they can be used as follows:
# hosted_zone_domain_name = local.account_vars.locals.top_level_domain_names.personal_website
locals {
  environment = "prod"
  domain_name = ".sajaroff.com."
}
