variable "environment" {
  description = "The name of the environment (e.g., dev, staging, prod)."
  type        = string
}

variable "location" {
  description = "The Azure region to create resources in."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_address_prefixes" {
  description = "The address prefix for the public subnet."
  type        = list(string)
}

variable "private_subnet_address_prefixes" {
  description = "The address prefix for the private subnet."
  type        = list(string)
}