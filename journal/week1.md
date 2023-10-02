# Terraform Beginner Bootcamp 2023 - Week 1

## Table of Contents

- [Root Module Structure](#root-module-structure)
- [Terraform and Input Variables](#terraform-and-input-variables)

## Root Module Structure

The Terraform root module structure is as follows:

```sh
PROJECT_ROOT
├── main.tf          # primary file
├── variables.tf     # stores input variables structure
├── terraform.tfvars # varable data to load into Terraform project
├── providers.tf     # defines required providers and configuration
├── outputs.tf       # stores outputs
└── README.md        # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform cloud Variables

In Terraform we can set two kinds of variables:

- Environment Variables
  * Those you would set in your bash terminal. Ex. AWS credentials.
- Terraform Variables
  * Those that you would normally set in your _tfvars_ file.

We can set Terraform Cloud variables to be sensitive so they're not visible in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

#### var flag
We can use the `-var` flag to set an input variable or override a variable in the _tfvars_ file. Ex. `terraform plan -var="user_uuid=my-user-id"`

#### var-file flag
Alternatively the `-var-file` flag accepts a file ending in `.tfvars` or `.tfvars.json` as input. Ex. `terraform plan -var-file="project.tfvars"`.

The `.tfvars` file follows the standard Terraform `.tfvars` format:

```ruby
user_uuid="my-user-id"
```

The `.tfvars.json` file encapsulates the variables in a _json_ payload:

```json
{
    "user_uuid": "my-user-id"
}
```

### terraform.tfvars

This is the default file to load Terraform variables in bulk.

### *.auto.tfvars

These files will automatically load variables into Terraform Cloud. Variables in these files take precedence over `terraform.tfvars` variables.

### Order of Terraform Variables

Terraform variables are loaded in the following order, with later definitions taking precedence: 

- environment variables
- `terraform.tfvars` file
- `terraform.tfvars.json` file
- `*.auto.tfvars` and `*.auto.tfvars.json` files in alphabetical file name order
- `-var` and `-var-file` CLI options in the order provided



:end:
