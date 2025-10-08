output "private_ips" {
  description = "The private IP addresses of the deployed VMs."
  value       = [for nic in azurerm_network_interface.nic : nic.private_ip_address]
}