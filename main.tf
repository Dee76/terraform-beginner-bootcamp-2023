terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  # backend "remote" {
  #   hostname = "app.terraform.io"
  #   organization = "deeTFCPBB"

  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
  # cloud {
  #   organization = "deeTFCPBB"
  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  assets_path = var.assets_path
  content_version = var.content_version
}

resource "terratowns_home" "lebowski_home" {
  name = "The Big Lebowski: A Philisophical Analysis"
  description = <<DESCRIPTION
The Big Lebowski is not only a cult comedy, but an interesting study in philisophical ideas.
Here we will introduce some of these ideas, along with showcasing the rise of Dudeism.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  # domain_name="3xf332sdfs.cloudfront.net"
  town = "missingo"
  content_version = var.content_version
}