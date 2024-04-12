output "container_app_environment_name" {
  value = module.container_apps.container_app_environment_name
}

output "dashboard_url" {
  value = module.container_apps.container_app_fqdn["dashboard"]
}
