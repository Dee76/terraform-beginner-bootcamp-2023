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
  cloud {
    organization = "deeTFCPBB"
    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_lebowski_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.lebowski.public_path
  content_version = var.lebowski.content_version
}

resource "terratowns_home" "home_lebowski" {
  name = "The Big Lebowski: A Philisophical Analysis"
  description = <<DESCRIPTION
The Big Lebowski is not only a cult comedy, but an interesting study in philisophical ideas.
Here we will introduce some of these ideas, along with showcasing the rise of Dudeism.
DESCRIPTION
  domain_name = module.home_lebowski_hosting.domain_name
  # domain_name="3xf332sdfs.cloudfront.net"
  town = "video-valley"
  content_version = var.lebowski.content_version
}

module "home_gfcake_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.gfcake.public_path
  content_version = var.gfcake.content_version
}

resource "terratowns_home" "home_gfcake" {
  name = "Gluten-Free Chocolate Cake"
  description = <<DESCRIPTION
Everyone loves cake. Chocolate cake especially.
But what if you're a Celiac, gluten intolerant, or have a wheat allergy?
Don't fret! Here's a recipe for a gluten-free chocolate cake you can enjoy!
DESCRIPTION
  domain_name = module.home_gfcake_hosting.domain_name
  # domain_name="3xf332sdfs.cloudfront.net"
  town = "cooker-cove"
  content_version = var.gfcake.content_version
}
