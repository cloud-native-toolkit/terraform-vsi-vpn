module "openvpn" {
  source = "./module"

  resource_group_id   = module.resource_group.id
  region              = var.region
  ibmcloud_api_key    = var.ibmcloud_api_key
  vpc_name            = module.vpc.name
  subnet_count        = module.openvpn-subnets.count
  subnets             = module.openvpn-subnets.subnets
  ssh_key_id          = module.vpcssh.id
  ssh_private_key     = module.vpcssh.private_key
  instance_count      = module.bastion.instance_count
  instance_network_ids = module.bastion.network_interface_ids
  allow_deprecated_image = false
}

resource null_resource print_private_key {
  provisioner "local-exec" {
    command = "echo 'Private key: ${module.vpcssh.private_key}'"
  }
}
