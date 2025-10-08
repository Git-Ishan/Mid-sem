output "app_gateway_public_ip" {
  description = "The public IP address of the Application Gateway."
  value       = azurerm_public_ip.app_gateway_ip.ip_address
}