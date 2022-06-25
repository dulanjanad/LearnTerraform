terraform {
  
}

variable "employee_details" {
  type = list
}

output "output_splat" {
  value = var.employee_details
}

#Access attributes
output "output_attrubute" {
  value = [ for i in var.employee_details : i.name ]
}

output "output_attrubute_first_index" {
  value = var.employee_details[0].name
}