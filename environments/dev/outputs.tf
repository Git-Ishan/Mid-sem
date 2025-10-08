output "app_gateway_ip" {
  description = "The public IP of the dev environment Application Gateway."
  value       = module.loadbalancer.app_gateway_public_ip
}