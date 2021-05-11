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
  acl_rules          = [{
    name="ingress-ssh"
    action="allow"
    direction="inbound"
    source="0.0.0.0/0"
    destination="0.0.0.0/0"
    tcp = {
      port_min=22
      port_max=22
      source_port_min=22
      source_port_max=22
    }
  }, {
    name="egress-ssh"
    action="allow"
    direction="outbound"
    destination="0.0.0.0/0"
    source="0.0.0.0/0"
    tcp = {
      port_min=22
      port_max=22
      source_port_min=22
      source_port_max=22
    }
  }]
}
