variable "environment" {
  description = "The name of the environment."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet for the Application Gateway."
  type        = string
}

variable "backend_ip_addresses" {
  description = "A list of private IP addresses for the backend VMs."
  type        = list(string)
}