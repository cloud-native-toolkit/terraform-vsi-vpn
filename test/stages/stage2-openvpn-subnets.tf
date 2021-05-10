module "openvpn-subnets" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpc-subnets.git"

  resource_group_id = module.resource_group.id
  region            = var.region
  ibmcloud_api_key  = var.ibmcloud_api_key
  vpc_name          = module.vpc.name
  vpc_id            = module.vpc.id
  gateways          = module.gateways.gateways
  _count            = 1
  label             = "openvpn"
}
