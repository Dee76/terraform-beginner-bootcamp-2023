terraform {
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

  required_providers {
    # random = {
    #   source = "hashicorp/random"
    #   version = "3.5.1"
    # }
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}



provider "aws" {
  # Configuration options
}

provider "random" {
  # Configuration options
}