variable "resource_group_id" {
  type        = string
  description = "The id of the IBM Cloud resource group where the resources will be provisioned."
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where the resources will be provisioned."
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud api token"
}

variable "tags" {
  type        = list(string)
  description = "List of tags"
  default     = []
}

variable "vpc_name" {
  type        = string
  description = "The name of the existing VPC instance"
}

variable "subnet_count" {
  type        = number
  description = "The number of subnets on the vpc instance"
}

variable "subnets" {
  type        = list(object({id = string, zone = string, label = string}))
  description = "The list of subnet objects where OpenVPN servers will be provisioned"
}

variable "ssh_key_id" {
  type        = string
  description = "The id of a key registered with the VPC"
}

variable "ssh_private_key" {
  type        = string
  description = "The private key that is paired with ssh_key_id"
}

variable "image_name" {
  type        = string
  default     = "ibm-centos-7-9-minimal-amd64-2"
  description = "Name of the image to use for the bastion instance"
}

variable "profile_name" {
  type        = string
  description = "Instance profile to use for the bastion instance"
  default     = "cx2-2x4"
}

variable "init_script" {
  type        = string
  default     = ""
  description = "Script to run during the instance initialization. Defaults to an Ubuntu specific script when set to empty"
}

variable "allow_ssh_from" {
  type        = string
  description = "An IP address, a CIDR block, or a single security group identifier to allow incoming SSH connection to the bastion"
  default     = "0.0.0.0/0"
}

variable "security_group_rules" {
  # type = list(object({
  #   name=string,
  #   direction=string,
  #   remote=optional(string),
  #   ip_version=optional(string),
  #   tcp=optional(object({
  #     port_min=number,
  #     port_max=number
  #   })),
  #   udp=optional(object({
  #     port_min=number,
  #     port_max=number
  #   })),
  #   icmp=optional(object({
  #     type=number,
  #     code=optional(number)
  #   })),
  # }))
  description = "List of security group rules to set on the bastion security group in addition to the SSH rules"
  default = [
    {
      name      = "http_outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
      tcp = {
        port_min = 80
        port_max = 80
      }
    },
    {
      name      = "https_outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
      tcp = {
        port_min = 443
        port_max = 443
      }
    },
    {
      name      = "dns_outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
      udp = {
        port_min = 53
        port_max = 53
      }
    },
    {
      name      = "icmp_outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
      icmp = {
        type = 8
      }
    },
    {
      name      = "vpn"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      udp = {
        port_min = 65000
        port_max = 65000
      }
    }
  ]
}

variable "instance_count" {
  type        = number
  description = "The number of jump box instances routable by the OpenVPN server"
}

variable "instance_network_ids" {
  type        = list(string)
  description = "The list of jump box network instance ids"
}
