# Terraform Beginner Bootcamp 2023 - Week 1

## Table of Contents

- [Fixing Tags](#fixing-tags)
- [Root Module Structure](#root-module-structure)
- [Terraform and Input Variables](#terraform-and-input-variables)
- [Dealing with Configuration Drift](#dealing-with-configuration-drift)
- [Terraform Modules](#terraform-modules)
- [Considerations When Using ChatGPT to Write Terraform](#considerations-when-using-chatgpt-to-write-terraform)
- [Working with Files in Terraform](#working-with-files-in-terraform)
- [Terraform Locals](#terraform-locals)
- [Terraform Data Sources](#terraform-data-sources)
- [Working with JSON](#working-with-json)
- [Change the Lifecycle of Resources](#change-the-lifecycle-of-resources)
- [Terraform Data](#terraform-data)

## Fixing Tags

[How to Delete Local and Remote Tags on Git ](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locally delete a tag:

```sh
git tag -d <tag_name>
```

Remotely delete a tag:

```sh
git push --delete origin tagname
``````

Checkout the commit that you want to retag. Grab the SHA from your Github history.

```sh
git checkout <SHA>
git tag <M.M.P>
git push --tags
git checkout main
```

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

```terraform
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

## Dealing with Configuration Drift

### What Happens if We Lose Our State File?

If the state file is lost, you most likely have to manually tear down all cloud infrastructure.

You can use `terraform import` however it won't work for all cloud resources. You need to check the Terraform providers documentation to determine which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.example bucket_name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/commands/import)

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and deletes or modifies cloud resources manually via "ClickOps", we can run `terraform plan` again and it will attempt to put our infrastructure back into the expected state.

### Fix Using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It's recommended to place modules in a `modules` sub directory when locally developing modules, however you can name it however you like.

### Passing Input Variables

We can pass input variables to our module.

The module has to declare the Terraform variables in it's own `variables.tf`.

```terraform
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module Sources

Using the source we can import the module from various places. Ex.:
- locally
- Github
- Terraform Registry

```terraform
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

Large Language Models (LLMs) used by ChatGPT may not be trained on the latest documentation or information about Terraform.

It may produce older example that could be deprecated. Often affecting providers.

## Working with Files in Terraform

### `fileexists` Function

`fileexists` is a built-in Terraform function to check if a file or directory exists.

[fileexists function](https://developer.hashicorp.com/terraform/language/functions/fileexists)

Example:

```terraform
condition = fileexists(var.index_html_filepath)
```

### `filemd5` Function

The `filemd5` function returns the _md5_ hash of the specified file.

[filemd5 Function](https://developer.hashicorp.com/terraform/language/functions/filemd5)

Example:

```terraform
etag = filemd5(var.index_html_filepath)
```

### Path Variables

In Terraform there is a special variable called `path` that allows us to reference local paths:

- `path.module` - get the path for the current module
- `path.root` - get the path for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

Example:

```terraform
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}
```

## Terraform Locals

Locals allow us to define variables locally.

They can be very useful when we need to transform data into other format and have it referenceable as a variable.

Example:

```terraform
locals {
  s3_origin_id = "myS3Origin"
}
```

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

This allows us to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

Example:

```terraform
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use `jsonencode` to create the json policy inline in the HCL.

Example:

```terraform
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

## Change the Lifecycle of Resources

`lifecycle` allows us to instruct Terraform how to treat the lifecycle of resources.

We used this with our S3 objects so that we can update when our `content_version` variable changes, ignoring changes to the files themselves.

Example:

```terraform
resource "aws_s3_object" "index_html" {
  # ...
  etag = filemd5(var.index_html_filepath)
  lifecycle {
    ignore_changes = [etag]
    replace_triggered_by = [terraform_data.content_version]
  }
}

```

[Lifecycle Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as _Local Values_ and _Input Variables_ don't have any side-effects to plan against and so they aren't valid in `replace_triggered_by`. You can use `terraform_data`'s behavior of planning an action each time `input` changes to indirectly use a plain value to trigger replacement.

Example:

```terraform
resource "terraform_data" "content_version" {
  input = var.content_version
}

resource "aws_s3_object" "index_html" {
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
  }
}
```

[terraform_data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Provisioners

Provisioners allow you to execute commands on compute instances. Ex. an AWS CLI command.

They are not recommended for use by _Hashicorp_ because Configuration Management tools such as _Ansible_ are a better fit, but the functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute a command on the machine running the `terraform` commands. Ex. `plan apply`.

Example:

```terraform
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

[`local-exec` Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as _ssh_ to get into the machine.

Example:

```terraform
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

[`remote-exec` Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

## `for` and `for_each` Expressions

`for` and `for_each` allow you to traverse collections of complex data types.

### `for`

`for` allows us to enumerate over complex data types and perform actions against them.

Example:

```terraform
[for s in var.list : upper(s)]
```

[For Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)

### `for_each`

Similar to `for`, `for_each` iterates over complex data types. It allows you to perform multiple commands by providing a reference to each item in the complex data type.

In our case, we passed a `fileset` to `for_each`, so it allowed us to reference each file as a set of keys via `each.key`.

Example:

```terraform
resource "aws_iam_user" "the-accounts" {
  for_each = toset( ["Todd", "James", "Alice", "Dottie"] )
  name     = each.key
}
```

[`for_each` Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

:end:
