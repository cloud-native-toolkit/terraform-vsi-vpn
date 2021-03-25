output vpc_name {
  value = data.ibm_is_vpc.vpc.name
}

output bastion_ip {
  value = module.bastion.bastion_public_ip
}

output bastion_private_ip {
  value = module.bastion.bastion_private_ip
}

output instance_ips {
  value = [
    for instance in local.instances : instance.primary_network_interface.0.primary_ipv4_address
  ]
}
