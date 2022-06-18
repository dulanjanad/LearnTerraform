terraform {

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "dulanjana"

    workspaces {
      name = "terraform-test-workspace"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.19.0"
    }
  }

}


locals {
  customer-name = "Symbox"
}