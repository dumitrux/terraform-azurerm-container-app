resource "azurerm_monitor_diagnostic_setting" "container_app" {
  count = var.monitoring_enabled ? 1 : 0

  name                       = "ContainerAppMetrics"
  target_resource_id         = azurerm_container_app.container_app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "metric" {
    for_each = toset(var.monitoring_metrics_container_app)

    content {
      category = metric.key
      enabled  = true
    }
  }

  dynamic "enabled_log" {
    for_each = toset(var.monitoring_logs_container_app)

    content {
      category = enabled_log.key
    }
  }
}
