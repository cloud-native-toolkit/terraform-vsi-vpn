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
  description = "The list of tags that will be applied to the OpenVPN vsi instances."
  default     = []
}

variable "vpc_name" {
  type        = string
  description = "The name of the existing VPC instance where the OpenVPN instance(s) will be provisioned."
}

variable "subnet_count" {
  type        = number
  description = "The number of subnets on the vpc instance that will be used for the OpenVPN instance(s)"
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
  default     = "ibm-ubuntu-20-04-minimal-amd64-2"
  description = "Name of the image to use for the OpenVPN instance"
}

variable "profile_name" {
  type        = string
  description = "Virtual Server Instance profile to use for the OpenVPN instance"
  default     = "bx2-2x8"
}

variable "allow_ssh_from" {
  type        = string
  description = "An IP address, a CIDR block, or a single security group identifier to allow incoming SSH connection to the OpenVPN instance"
  default     = "0.0.0.0/0"
}

variable "security_group_rules" {
  type = list(object({}))
//  type = list(object({
//    name=string,
//    direction=string,
//    remote=optional(string),
//    ip_version=optional(string),
//    tcp=optional(object({
//      port_min=number,
//      port_max=number
//    })),
//    udp=optional(object({
//      port_min=number,
//      port_max=number
//    })),
//    icmp=optional(object({
//      type=number,
//      code=optional(number)
//    })),
//  }))
  description = "List of security group rules to set on the OpenVPN security group in addition to inbound SSH and VPC and outbound DNS, ICMP, and HTTP(s) rules"
  default = []
}

variable "instance_count" {
  type        = number
  description = "The number of Bastion/jump box instances routable by the OpenVPN server."
}

variable "instance_network_ids" {
  type        = list(string)
  description = "The list of network interface ids for the Bastion/jump box servers."
}

variable "kms_enabled" {
  type        = bool
  description = "Flag indicating that the volumes should be encrypted using a KMS."
  default     = false
}

variable "kms_key_crn" {
  type        = string
  description = "The crn of the root key in the kms instance. Required if kms_enabled is true"
  default     = ""
}

variable "allow_deprecated_image" {
  type        = bool
  description = "Flag indicating that deprecated images should be allowed for use in the Virtual Server instance. If the value is `false` and the image is deprecated then the module will fail to provision"
  default     = true
}

variable "base_security_group" {
  type        = string
  description = "The id of the base security group to use for the VSI instance. If not provided the default VPC security group will be used."
  default     = null
}
