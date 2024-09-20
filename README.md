# Cloud Infrastructure organization
Source of truth for all the infrastructure as code deployed in the cloud providers I own.

This repository serves as a working example on creating a fully functional infrastructure for different types of projects, some of them examples, some of them actual infrastructure.

It attempts to compare and provide insight on how different cloud providers manage resources.

It provides:
* Modular stack
* Dependency management. Import and export dependencies using `terragrunt`'s `dependency` block
* Terraform state and lock configuration and management
* Costs breakdown with `infracosts`

The source code is shared under the BSD 2-Clause license.

# Project structure
Different providers have its own [folders](./terraform/) within the `terraform` folder.

There are 2 main environments: *prod* and *non-prod*.

## Opentofu & Terraform
[Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/quick-start/#introduction) will be used to orchestrate all `terraform` / `tofu` code.

### terraform/aws
```
├── non-prod
│   ├── account.hcl
│   └── eu-west-1
│       ├── dev
│       │   ├── common_vars.yaml
│       │   ├── env.hcl
│       │   ├── mailserver
│       │   │   └── terragrunt.hcl
│       │   ├── network
│       │   │   ├── outputs.tf
│       │   │   ├── sg.tf
│       │   │   └── terragrunt.hcl
│       │   ├── s3_cdn
│       │   │   └── terragrunt.hcl
│       │   └── s3_website
│       │       └── terragrunt.hcl
│       ├── region.hcl
│       └── sandbox
│           ├── common_vars.yaml
│           ├── env.hcl
│           ├── mailserver
│           │   └── terragrunt.hcl
│           └── network
│               ├── outputs.tf
│               ├── sg.tf
│               └── terragrunt.hcl
├── prod
└── terragrunt.hcl
```

### Modules
Modules must work with both tf and tofu.

* [Amazon Web Services](https://github.com/asajaroff/tofu-aws-modules/tree/main)
* [Azure](https://github.com/asajaroff/tofu-azure-modules/tree/main)
* [Digital Ocean](https://github.com/asajaroff/tofu-do-modules/tree/main)
* [Google Cloud Platform](https://github.com/asajaroff/tofu-gcp-modules/tree/main)

To import a module from the library, use:
```bash
terragrunt catalog https://github.com/asajaroff/tofu-aws-modules//
```

## Ansible
Yet to be completed.

## Polumi
Yet to be completed.

## Crossplane.io
Yet to be completed.
