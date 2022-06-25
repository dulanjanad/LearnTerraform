terraform {
  
}

variable "var_1" {
  type = string
}

variable "var_2" {
  type = string
}

#Interpolation
output "sample_output_1" {
  value = "Hello ${var.var_1}"
}

#If Else
output "sample_output_2" {
  value = "Bruno %{if var.var_2 == "Bruno"}Mars%{else}World%{endif}"
}