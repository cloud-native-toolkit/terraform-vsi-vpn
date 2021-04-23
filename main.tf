
locals {
  vpc_id           = data.ibm_is_vpc.vpc.id
  name             = "${var.vpc_name}-openvpn"
  attachment_count = var.subnet_count * var.instance_count
  tmp_attachments  = tolist(setproduct(module.openvpn-server[*].bastion_maintenance_group_id, var.instance_network_ids))
  attachments      = [for val in local.tmp_attachments: {security_group_id = val[0], network_interface_id = val[1]}]
}

resource null_resource print-vpc_name {
  provisioner "local-exec" {
    command = "echo 'VPC name: ${var.vpc_name}'"
  }
}

# get the information about the existing vpc instance
data ibm_is_vpc vpc {
  depends_on = [null_resource.print-vpc_name]

  name           = var.vpc_name
}

# The open vpn server is installed into a bastion server
module openvpn-server {
  source  = "we-work-in-the-cloud/vpc-bastion/ibm"
  version = "0.0.5"

  count = var.subnet_count

  name              = "${local.name}-${format("%02s", count.index)}"
  resource_group_id = var.resource_group_id
  vpc_id            = data.ibm_is_vpc.vpc.id
  subnet_id         = var.subnets[count.index].id
  ssh_key_ids       = [var.ssh_key_id]
  tags              = var.tags
  init_script       = file("${path.module}/scripts/instance-init.sh")
  image_name        = var.image_name
  profile_name      = var.profile_name
  allow_ssh_from    = var.allow_ssh_from
}

resource null_resource setup_openvpn {
  provisioner "file" {
    source      = "${path.module}/scripts/openvpn-config.sh"
    destination = "/usr/local/bin/openvpn-config.sh"
  }

  count = var.subnet_count
  depends_on = [module.openvpn-server]

  connection {
    type        = "ssh"
    user        = "root"
    password    = ""
    private_key = var.ssh_private_key
    host        = module.openvpn-server[count.index].bastion_public_ip
  }

  provisioner "remote-exec" {
    inline     = [
      "chmod +x /usr/local/bin/openvpn-config.sh",
      "openvpn-config.sh"
    ]
  }
}

resource ibm_is_security_group_network_interface_attachment under_maintenance {
  count = local.attachment_count

  security_group    = local.attachments[count.index].security_group_id
  network_interface = local.attachments[count.index].network_interface_id
}
