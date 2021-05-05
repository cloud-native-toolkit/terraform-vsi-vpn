output "ids" {
  value       = module.openvpn-server.ids
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

output "security_group_ids" {
  value       = module.openvpn-server.security_group_id
  description = "ID of the security group assigned to the OpenVPN interface"
}
