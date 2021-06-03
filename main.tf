
locals {
  tmp_dir          = "${path.cwd}/.tmp"
  vpc_id           = data.ibm_is_vpc.vpc.id
  name             = "${var.vpc_name}-openvpn"
  attachment_count = var.subnet_count * var.instance_count
  tmp_attachments  = tolist(setproduct([module.openvpn-server.maintenance_security_group_id], var.instance_network_ids))
  attachments      = [for val in local.tmp_attachments: {security_group_id = val[0], network_interface_id = val[1]}]
  ip_file          = "${local.tmp_dir}/pubip.txt"
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

module "openvpn-server" {
  source = "github.com/cloud-native-toolkit/terraform-vsi-bastion.git?ref=v1.6.0"

  resource_group_id    = var.resource_group_id
  region               = var.region
  ibmcloud_api_key     = var.ibmcloud_api_key
  vpc_name             = var.vpc_name
  vpc_subnet_count     = var.subnet_count
  vpc_subnets          = var.subnets
  image_name           = var.image_name
  profile_name         = var.profile_name
  ssh_key_id           = var.ssh_key_id
  kms_key_crn          = var.kms_key_crn
  kms_enabled          = var.kms_enabled
  init_script          = file("${path.module}/scripts/instance-init.sh")
  create_public_ip     = true
  allow_ssh_from       = var.allow_ssh_from
  tags                 = var.tags
  label                = "vpn"
  allow_deprecated_image = var.allow_deprecated_image
  security_group_rules = concat(var.security_group_rules, [
    {
      name      = "openvpn"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      udp = {
        port_min = 1194
        port_max = 1194
      }
    },
    {
      name      = "outbound-internal-ssh"
      direction = "outbound"
      remote    = "10.0.0.0/8"
      tcp = {
        port_min = 22
        port_max = 22
      }
    },
    {
      name      = "outbound-roks-private"
      direction = "outbound"
      remote    = "166.8.0.0/14"
    }
  ])
  base_security_group  = var.base_security_group
}

resource null_resource print_ips {
  provisioner "local-exec" {
    command = "echo 'Public ips: ${join(",",module.openvpn-server.public_ips)}'"
  }
}
  
resource null_resource print-float_ip {
  provisioner "local-exec" {
    command = "mkdir -p ${local.tmp_dir} && echo ${join(",", module.openvpn-server.public_ips)} > ${local.ip_file}"
  }
}

data ibm_is_subnet subnet {
  count = var.subnet_count > 0 ? 1 : 0

  identifier = var.subnets[0].id
}

resource null_resource open_acl_rules {
  count = var.subnet_count > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "${path.module}/scripts/open-acl-rules.sh '${data.ibm_is_subnet.subnet[0].network_acl}' '${var.region}' '${var.resource_group_id}'"

    environment = {
      IBMCLOUD_API_KEY = var.ibmcloud_api_key
    }
  }
}

resource null_resource setup_openvpn {
  count = var.subnet_count
  depends_on = [module.openvpn-server, null_resource.print_ips, null_resource.print-float_ip, null_resource.open_acl_rules]

  connection {
    type        = "ssh"
    user        = "root"
    password    = ""
    private_key = var.ssh_private_key
    host        = module.openvpn-server.public_ips[count.index]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/openvpn-config.sh"
    destination = "/usr/local/bin/openvpn-config.sh"
  }

  provisioner "file" {
    source      = local.ip_file
    destination = "/tmp/pubip.txt"
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
