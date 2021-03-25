
data ibm_resource_group group {
  name = var.resource_group_name
}

locals {
  prefix_name    = lower(replace(var.name_prefix != "" ? var.name_prefix : var.resource_group_name, "_", "-"))
  ssh_key_ids    = [ibm_is_ssh_key.generated_key.id]
  subnets        = data.ibm_is_subnet.vpc_subnet
  bastion_subnet = local.subnets.0
  instances      = module.vsi-instance.instances
}

resource null_resource print-vpc_name {
  provisioner "local-exec" {
    command = "echo ${var.vpc_name}"
  }
}

# get the information about the existing vpc instance
data ibm_is_vpc vpc {
  depends_on = [null_resource.print-vpc_name]

  name           = var.vpc_name
}

data ibm_is_subnet vpc_subnet {
  count = var.subnet_count

  identifier = data.ibm_is_vpc.vpc.subnets[count.index].id
}

resource tls_private_key ssh {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# generate ssh key
resource ibm_is_ssh_key generated_key {
  name           = "${local.prefix_name}-${var.region}-key"
  public_key     = tls_private_key.ssh.public_key_openssh
  resource_group = data.ibm_resource_group.group.id
  tags           = concat(var.tags, ["vpc"])
}

# create the vsi instance
module vsi-instance {
  source = "./submodules/vsi-instance"

  name              = "${local.prefix_name}-bastion-instance"
  resource_group_id = data.ibm_resource_group.group.id
  vpc_id            = data.ibm_is_vpc.vpc.id
  vpc_subnets       = local.subnets
  ssh_key_ids       = local.ssh_key_ids
  tags              = concat(var.tags, ["instance"])
}

module "bastion" {
  source  = "we-work-in-the-cloud/vpc-bastion/ibm"
  version = "0.0.5"

  name              = "${local.prefix_name}-bastion"
  resource_group_id = data.ibm_resource_group.group.id
  vpc_id            = data.ibm_is_vpc.vpc.id
  subnet_id         = local.bastion_subnet.id
  ssh_key_ids       = local.ssh_key_ids
  tags              = concat(var.tags, ["bastion"])
}

# open the VPN port on the bastion
resource ibm_is_security_group_rule vpn {
  group     = module.bastion.bastion_security_group_id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  udp {
    port_min = 65000
    port_max = 65000
  }
}

#
# Allow all hosts created by this script to be accessible by the bastion
#
resource "ibm_is_security_group_network_interface_attachment" "under_maintenance" {
  count = length(local.instances)

  network_interface = local.instances[count.index].primary_network_interface.0.id
  security_group    = module.bastion.bastion_maintenance_group_id
}

#
# Ansible playbook to install OpenVPN
#
module ansible {
  source = "./submodules/ansible"

  bastion_ip             = module.bastion.bastion_public_ip
  instances              = local.instances
  subnets                = local.subnets
  private_key_pem        = tls_private_key.ssh.private_key_pem
  openvpn_server_network = var.openvpn_server_network
}
