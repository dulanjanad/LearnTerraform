terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.20.1"
    }
  }
}

variable "instance_type" {
  type = string
}

variable "current_public_ip" {
  type = string
}

locals {
  ingress = [
    {
      port        = 443
      description = "Allow HTTPS"
      protocol    = "tcp"
    },
    {
      port        = 22
      description = "Allow SSH from my local machine"
      protocol    = "tcp"
    },
    {
      port        = 80
      description = "Allow HTTP Traffice"
      protocol    = "tcp"
    }
  ]
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "my-server" {
  ami                    = data.aws_ami.red_hat_image.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_traffice.id]

  tags = {
    "Name"        = "app-node-1.example.com"
    "Environment" = "Dev"
  }

  lifecycle {
    prevent_destroy = false
  }
}

data "aws_ami" "red_hat_image" {
  most_recent = true
  owners      = ["309956199498"] // Red Hat's account ID.

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["RHEL-8*"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIYLxLtWVp/gFXVCsswSG9Ez9QXIgxNnOWaJGlJTyUysabQZEgO7mjWVPcHIGoA+H0CbE/kRsitsNrlTWnPrCXQbQ/2MwSx4EgcOfMdn4Urgw94bzGqrNsDqoAiI+X2ofg1mkn7Q2wKY8gaG8f3/GDZnCSqEsjAHepNqd2CZn0nkg53mwqcsXjUSUPAIMQlKIOfILvIXP2rEZVDWeW4mxY/KnWP2J2UAK9EkYawPZAJPqbN8fDgFTpkKmNhGmA73qMeW4hn/7DN8227OA0aKQshAwJfuaOgTkxDeiE0HDUeLPhfyDP8yw+6jnbg94gEW7tT71AyvCmU9BW1MwJ+prWpibONqf0/NUHuajtZHNLqN+toFcVvtH5cWqTPy3qiziC9GsR7JJ44evXaCZ2/80k5oUGvcR2ZwtkWeueqECIsjk00yOjzDYBXylj8Z6Z6hypkdI2FTN2+0LAfFG7KOXUpus3GVALUkd5fNohV9vLvcoYsnG9YV4SbUDGldJ3cOs="
}

resource "aws_security_group" "allow_traffice" {
  name        = "Secondary Security Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default_vpc.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ["${var.current_public_ip}"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name"        = "Secondary Security Group"
    "Environment" = "Dev"
  }
}

resource "aws_default_vpc" "default_vpc" {

}

output "instance_public_ip" {
  value = aws_instance.my-server.public_ip
}

output "instance_private_ip" {
  value = aws_instance.my-server.private_ip
}