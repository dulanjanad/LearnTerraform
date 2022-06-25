terraform {
  
}

variable "colors" {
  type = list
}

variable "people" {
  type = map
}

output "upper_case_out" {
  value =  [for c in var.colors : upper(c)]
}

output "output_index" {
  value = [for i,c in var.colors : i]
}

output "output_map_values" {
  value = [for k,v in var.people : v]
}

output "output_list" {
  value = [{for k,v in var.colors : k => v}]
}

output "output_map" {
  value = [{for k,v in var.people : k => v}]
}