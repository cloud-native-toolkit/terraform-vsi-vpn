module "bastion-subnets" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpc-subnets.git"

  resource_group_name = module.resource_group.name
  region            = var.region
  vpc_name          = module.vpc.name
  gateways          = module.gateways.gateways
  _count            = 1
  label             = "bastion"
}
