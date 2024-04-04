output "container_app_environment_id" {
  description = "The ID of the Container App Environment within which this Container App should exist."
  value       = module.container_app.container_app_environment_id
}

output "container_app_fqdn" {
  description = "The FQDN of the Container App's ingress."
  value       = module.container_app.container_app_fqdn
}

output "container_app_ips" {
  description = "The IPs of the Latest Revision of the Container App."
  value       = module.container_app.container_app_ips
}

output "container_app_name" {
  description = "The name of the Container App."
  value       = module.container_app.container_app_name
}
