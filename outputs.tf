output "ids" {
  value       = module.openvpn-server[*].bastion_id
  description = "ID of the OpenVPN virtual server instance"
}

output "count" {
  value       = var.subnet_count
  description = "ID of the OpenVPN virtual server instance"
}

output "private_ips" {
  value       = module.openvpn-server[*].bastion_private_ip
  description = "Private IP address of the OpenVPN virtual server instance"
}

output "public_ips" {
  value       = module.openvpn-server[*].bastion_public_ip
  description = "Public IP address of the OpenVPN virtual server instance"
}

output "security_group_ids" {
  value       = module.openvpn-server[*].bastion_security_group_id
  description = "ID of the security group assigned to the OpenVPN interface"
}

output "maintenance_security_group_ids" {
  value       = module.openvpn-server[*].bastion_maintenance_group_id
  description = "ID of the security group used to allow connection from OpenVPN to your bastion instances"
}
