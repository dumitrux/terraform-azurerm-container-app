# [Diagnostic Setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)
resource "azurerm_monitor_diagnostic_setting" "container_apps" {
  for_each = { for container_app in var.container_apps : container_app.name => container_app if var.monitoring_enabled }

  name                       = "${each.value.name}-diagnostic-settings"
  target_resource_id         = azurerm_container_app.container_app[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "metric" {
    for_each = toset(var.container_app_diagnostic_category.metric)

    content {
      category = metric.key
      enabled  = true
    }
  }

  dynamic "enabled_log" {
    for_each = toset(var.container_app_diagnostic_category.log)

    content {
      category = enabled_log.key
    }
  }
}
