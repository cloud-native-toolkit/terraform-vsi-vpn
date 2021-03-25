variable "resource_group_name" {
  type        = string
  description = "The name of the IBM Cloud resource group where the cluster will be created/can be found."
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where the cluster will be/has been installed."
}

variable "name_prefix" {
  type        = string
  description = "The name of the vpc resource"
  default     = ""
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
  description = "The name of the vpc instance"
}

variable "subnet_count" {
  type        = number
  description = "The number of subnets on the vpc instance"
}

variable "openvpn_server_network" {
  default = "10.66.0.0"
}
