module "bastion" {
  source = "github.com/cloud-native-toolkit/terraform-vsi-bastion.git"

  resource_group_id   = module.resource_group.id
  region              = var.region
  ibmcloud_api_key    = var.ibmcloud_api_key
  vpc_name            = module.vpc.name
  vpc_subnet_count    = module.bastion-subnets.count
  vpc_subnets         = module.bastion-subnets.subnets
  ssh_key_id          = module.vpcssh.id
}
