output "ids" {
  value       = module.openvpn-server.ids
  description = "ID of the OpenVPN virtual server instance"
}

output "names" {
  value       = module.openvpn-server.names
  description = "ID of the OpenVPN virtual server instance"
}

output "count" {
  value       = var.subnet_count
  description = "ID of the OpenVPN virtual server instance"
}

output "private_ips" {
  value       = module.openvpn-server.private_ips
  description = "Private IP address of the OpenVPN virtual server instance"
}

output "public_ips" {
  value       = module.openvpn-server.public_ips
  description = "Public IP address of the OpenVPN virtual server instance"
}

output "security_group_id" {
  description = "The id of the security group that was created"
  value       = module.openvpn-server.security_group_id
}

output "security_group" {
  description = "The security group that was created"
  value       = module.openvpn-server.security_group
}

output "maintenance_security_group_id" {
  description = "The id of the security group that was created"
  value       = module.openvpn-server.maintenance_security_group_id
}
