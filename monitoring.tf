# [Diagnostic Setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)
resource "azurerm_monitor_diagnostic_setting" "container_apps" {
  for_each = azurerm_container_app.container_app

  name                       = "diagnostic-settings-${each.value.name}"
  target_resource_id         = each.value.id
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
