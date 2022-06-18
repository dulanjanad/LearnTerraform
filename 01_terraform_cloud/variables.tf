variable "instance_type" {
  type = string
}

variable "additional_tags" {
  type = map(string)
}

variable "ami" {
  type = string
}

#terraform_cloud