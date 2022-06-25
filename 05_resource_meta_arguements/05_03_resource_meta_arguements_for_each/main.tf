terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.19.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-2"
}

variable "instance_type" {
  type = string
  description = "Instance type for EC2"

}

variable "ami" {
  type = string
}

variable "additional_tags" {
  type = map(string)
}

locals {
  customer-name = "ABC"
}

resource "aws_instance" "app_server" {

  for_each = {
    "jump-node" = "t2.micro"
    "app-node-1" = "t2.micro"
    "app-node-2" = "t2.micro"
  }

  ami           = var.ami
  instance_type = each.value
  key_name = aws_key_pair.deployer.key_name

  tags = merge(
    var.additional_tags,
    {
      Name = "${each.key}.example.com"
      Customer = "${local.customer-name}"
    }
  )
  
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIYLxLtWVp/gFXVCsswSG9Ez9QXIgxNnOWaJGlJTyUysabQZEgO7mjWVPcHIGoA+H0CbE/kRsitsNrlTWnPrCXQbQ/2MwSx4EgcOfMdn4Urgw94bzGqrNsDqoAiI+X2ofg1mkn7Q2wKY8gaG8f3/GDZnCSqEsjAHepNqd2CZn0nkg53mwqcsXjUSUPAIMQlKIOfILvIXP2rEZVDWeW4mxY/KnWP2J2UAK9EkYawPZAJPqbN8fDgFTpkKmNhGmA73qMeW4hn/7DN8227OA0aKQshAwJfuaOgTkxDeiE0HDUeLPhfyDP8yw+6jnbg94gEW7tT71AyvCmU9BW1MwJ+prWpibONqf0/NUHuajtZHNLqN+toFcVvtH5cWqTPy3qiziC9GsR7JJ44evXaCZ2/80k5oUGvcR2ZwtkWeueqECIsjk00yOjzDYBXylj8Z6Z6hypkdI2FTN2+0LAfFG7KOXUpus3GVALUkd5fNohV9vLvcoYsnG9YV4SbUDGldJ3cOs="
}

output "instance_private_ip" {
  value = values(aws_instance.app_server)[*].private_ip
}

output "instance_public_ip" {
  value = values(aws_instance.app_server)[*].public_ip
}