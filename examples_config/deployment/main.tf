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
module "container_apps" {
  source = "../.."

  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  tags                = var.tags

  # Container App
  container_app_environment_name = "container-app-env"

  container_apps = {
    counting = {
      name          = "counting-app"
      revision_mode = "Single"

      template = {
        containers = [
          {
            name   = "countingservicetest1"
            memory = "0.5Gi"
            cpu    = 0.25
            image  = "docker.io/hashicorp/counting-service:0.0.2"
            env = [
              {
                name  = "PORT"
                value = "9001"
              }
            ]
          },
        ]
      }

      ingress = {
        allow_insecure_connections = true
        external_enabled           = true
        target_port                = 9001
        traffic_weight = {
          latest_revision = true
          percentage      = 100
        }
      }
    },
    dashboard = {
      name          = "dashboard-app"
      revision_mode = "Single"

      template = {
        containers = [
          {
            name   = "testdashboard"
            memory = "1Gi"
            cpu    = 0.5
            image  = "docker.io/hashicorp/dashboard-service:0.0.4"
            env = [
              {
                name  = "PORT"
                value = "8080"
              },
              {
                name  = "COUNTING_SERVICE_URL"
                value = "http://counting-app"
              }
            ]
          },
        ]
      }

      ingress = {
        allow_insecure_connections = false
        target_port                = 8080
        external_enabled           = true

        traffic_weight = {
          latest_revision = true
          percentage      = 100
        }
      }
      identity = {
        type = "SystemAssigned"
      }
    },
  }

  # Monitoring
  monitoring_enabled         = var.monitoring_enabled
  log_analytics_workspace_id = var.monitoring_enabled ? azurerm_log_analytics_workspace.test[0].id : var.log_analytics_workspace_id
}
