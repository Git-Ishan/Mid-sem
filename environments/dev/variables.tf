variable "resource_group_name" {
  description = "Name of the Azure resource group for the dev environment."
  type        = string
  default     = "dev-rg-web"
}

variable "location" {
  description = "Azure region for the dev environment."
  type        = string
  default     = "East US"
}

variable "public_subnet_address_prefixes" {
  description = "Address prefix for the public subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_address_prefixes" {
  description = "Address prefix for the private subnet."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "vm_size" {
  description = "Size of the virtual machine for the dev environment."
  type        = string
  default     = "Standard_B1s"
}

variable "vm_count" {
  description = "Number of VMs to deploy in the dev environment."
  type        = number
  default     = 1
}

variable "admin_password" {
  description = "Admin password for the dev VMs. Input this during apply."
  type        = string
  sensitive   = true
}