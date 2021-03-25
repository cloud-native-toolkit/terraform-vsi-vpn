module "bastion" {
  source = "./module"

  resource_group_name = var.resource_group_name
  region              = var.region
  name_prefix         = var.name_prefix
  ibmcloud_api_key    = var.ibmcloud_api_key
  vpc_name            = module.vpc.name
  subnet_count        = module.vpc.subnet_count
}
