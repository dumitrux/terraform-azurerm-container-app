resource "azurerm_container_app_environment" "container_env" {
  name                       = "Example-Environment"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

# [Container App](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app)
resource "azurerm_container_app" "container_app" {
  name                         = "example-app"
  container_app_environment_id = azurerm_container_app_environment.container_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.container_app_revision_mode

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}
