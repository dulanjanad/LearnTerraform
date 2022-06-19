terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.19.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "Ireland"
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2"

}

data "aws_ami" "red-hat-image" {

  provider = aws.Ireland
  most_recent = true
  owners = ["309956199498"] // Red Hat's account ID.

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["RHEL-8*"]
  }

}

variable "additional_tags" {
  type = map(string)
}

locals {
  customer-name = "ABC"
}

resource "aws_instance" "app_server" {

  ami           = data.aws_ami.red-hat-image.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  provider      = aws.Ireland

  tags = merge(
    var.additional_tags,
    {
      Customer = "${local.customer-name}"
    }
  )

}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIYLxLtWVp/gFXVCsswSG9Ez9QXIgxNnOWaJGlJTyUysabQZEgO7mjWVPcHIGoA+H0CbE/kRsitsNrlTWnPrCXQbQ/2MwSx4EgcOfMdn4Urgw94bzGqrNsDqoAiI+X2ofg1mkn7Q2wKY8gaG8f3/GDZnCSqEsjAHepNqd2CZn0nkg53mwqcsXjUSUPAIMQlKIOfILvIXP2rEZVDWeW4mxY/KnWP2J2UAK9EkYawPZAJPqbN8fDgFTpkKmNhGmA73qMeW4hn/7DN8227OA0aKQshAwJfuaOgTkxDeiE0HDUeLPhfyDP8yw+6jnbg94gEW7tT71AyvCmU9BW1MwJ+prWpibONqf0/NUHuajtZHNLqN+toFcVvtH5cWqTPy3qiziC9GsR7JJ44evXaCZ2/80k5oUGvcR2ZwtkWeueqECIsjk00yOjzDYBXylj8Z6Z6hypkdI2FTN2+0LAfFG7KOXUpus3GVALUkd5fNohV9vLvcoYsnG9YV4SbUDGldJ3cOs="
}

output "instance_private_ip" {
  value = aws_instance.app_server.private_ip
}

output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}