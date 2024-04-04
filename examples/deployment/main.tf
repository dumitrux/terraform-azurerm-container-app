terraform {
  # https://github.com/hashicorp/terraform/tags
  required_version = "~> 1.0"

  required_providers {
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Get deployment context for role assignment
data "azurerm_client_config" "context" {}

# Provision dependent resource group
resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = var.location
}

# Provision optional resources for testing monitoring
resource "azurerm_log_analytics_workspace" "test" {
  count = var.monitoring_enabled ? 1 : 0

  name                = "log-${var.resource_suffix}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = var.tags
}

# Local Container App module
module "container_app" {
  source = "../.."

  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  resource_suffix     = var.resource_suffix
  tags                = var.tags

  # Container App
  container_app_revision_mode = var.container_app_revision_mode

  # Monitoring
  monitoring_enabled         = var.monitoring_enabled
  log_analytics_workspace_id = var.monitoring_enabled ? azurerm_log_analytics_workspace.test[0].id : var.log_analytics_workspace_id
}
