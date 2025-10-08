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

variable "private_subnet_id" {
  description = "The ID of the private subnet to deploy VMs into."
  type        = string
}

variable "nsg_id" {
  description = "The ID of the Network Security Group to associate with the VM NIC."
  type        = string
}

variable "vm_size" {
  description = "The size of the VM."
  type        = string
}

variable "admin_password" {
  description = "The password for the admin user on the VM."
  type        = string
  sensitive   = true
}

variable "vm_count" {
  description = "The number of VMs to deploy."
  type        = number
}

variable "user_data_script" {
  description = "The base64-encoded user data script from the nginx-app module."
  type        = string
}