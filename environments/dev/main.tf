module "network" {
  source                          = "../../modules/networking"
  environment                     = "dev"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  public_subnet_address_prefixes  = var.public_subnet_address_prefixes
  private_subnet_address_prefixes = var.private_subnet_address_prefixes
}

module "nginx_app" {
  source      = "../../modules/nginx"
  environment = "dev"
}

module "compute" {
  source              = "../../modules/compute"
  environment         = "dev"
  location            = module.network.location
  resource_group_name = module.network.resource_group_name
  private_subnet_id   = module.network.private_subnet_id
  nsg_id              = module.network.nsg_id
  vm_size             = var.vm_size
  admin_password      = var.admin_password
  vm_count            = var.vm_count
  user_data_script    = module.nginx_app.user_data_script
}

module "loadbalancer" {
  source               = "../../modules/loadbalancer"
  environment          = "dev"
  location             = module.network.location
  resource_group_name  = module.network.resource_group_name
  public_subnet_id     = module.network.public_subnet_id
  backend_ip_addresses = module.compute.private_ips
}