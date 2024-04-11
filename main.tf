locals {
  container_app_environment_id = try(data.azurerm_container_app_environment.container_env[0].id, azurerm_container_app_environment.container_env[0].id)
  container_app_environment_name = try(data.azurerm_container_app_environment.container_env[0].name, azurerm_container_app_environment.container_env[0].name)
}

# [Data Source Container App Environment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_app_environment)
data "azurerm_container_app_environment" "container_env" {
  count = var.container_app_environment != null ? 1 : 0

  name                = var.container_app_environment.name
  resource_group_name = var.container_app_environment.resource_group_name
}

# [Container App Environment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment)
resource "azurerm_container_app_environment" "container_env" {
  count = var.container_app_environment == null ? 1 : 0

  location            = var.location
  name                = var.container_app_environment_name
  resource_group_name = var.resource_group_name
  tags                = var.tags

  infrastructure_subnet_id       = var.container_app_environment_infrastructure_subnet_id
  internal_load_balancer_enabled = var.container_app_environment_internal_load_balancer_enabled
  log_analytics_workspace_id     = var.log_analytics_workspace_id

  lifecycle {
    precondition {
      condition     = var.container_app_environment_internal_load_balancer_enabled == null || var.container_app_environment_infrastructure_subnet_id != null
      error_message = "`var.container_app_environment_internal_load_balancer_enabled` can only be set when `var.container_app_environment_infrastructure_subnet_id` is specified."
    }
  }
}

# [Container App](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app)
resource "azurerm_container_app" "container_app" {
  for_each = var.container_apps

  container_app_environment_id = local.container_app_environment_id
  name                         = each.value.name
  resource_group_name          = var.resource_group_name
  tags                         = var.tags

  revision_mode         = each.value.revision_mode
  workload_profile_name = each.value.workload_profile_name

  template {
    max_replicas    = each.value.template.max_replicas
    min_replicas    = each.value.template.min_replicas
    revision_suffix = each.value.template.revision_suffix

    dynamic "container" {
      for_each = each.value.template.containers

      content {
        cpu     = container.value.cpu
        image   = container.value.image
        memory  = container.value.memory
        name    = container.value.name
        args    = container.value.args
        command = container.value.command

        dynamic "env" {
          for_each = container.value.env == null ? [] : container.value.env

          content {
            name        = env.value.name
            secret_name = env.value.secret_name
            value       = env.value.value
          }
        }

        dynamic "liveness_probe" {
          for_each = container.value.liveness_probe == null ? [] : [container.value.liveness_probe]

          content {
            port                    = liveness_probe.value.port
            transport               = liveness_probe.value.transport
            failure_count_threshold = liveness_probe.value.failure_count_threshold
            host                    = liveness_probe.value.host
            initial_delay           = liveness_probe.value.initial_delay
            interval_seconds        = liveness_probe.value.interval_seconds
            path                    = liveness_probe.value.path
            timeout                 = liveness_probe.value.timeout

            dynamic "header" {
              for_each = liveness_probe.value.header == null ? [] : [liveness_probe.value.header]

              content {
                name  = header.value.name
                value = header.value.value
              }
            }
          }
        }

        dynamic "readiness_probe" {
          for_each = container.value.readiness_probe == null ? [] : [container.value.readiness_probe]

          content {
            port                    = readiness_probe.value.port
            transport               = readiness_probe.value.transport
            failure_count_threshold = readiness_probe.value.failure_count_threshold
            host                    = readiness_probe.value.host
            interval_seconds        = readiness_probe.value.interval_seconds
            path                    = readiness_probe.value.path
            success_count_threshold = readiness_probe.value.success_count_threshold
            timeout                 = readiness_probe.value.timeout

            dynamic "header" {
              for_each = readiness_probe.value.header == null ? [] : [readiness_probe.value.header]

              content {
                name  = header.value.name
                value = header.value.value
              }
            }
          }
        }

        dynamic "startup_probe" {
          for_each = container.value.startup_probe == null ? [] : [container.value.startup_probe]

          content {
            port                    = startup_probe.value.port
            transport               = startup_probe.value.transport
            failure_count_threshold = startup_probe.value.failure_count_threshold
            host                    = startup_probe.value.host
            interval_seconds        = startup_probe.value.interval_seconds
            path                    = startup_probe.value.path
            timeout                 = startup_probe.value.timeout

            dynamic "header" {
              for_each = startup_probe.value.header == null ? [] : [startup_probe.value.header]

              content {
                name  = header.value.name
                value = header.value.name
              }
            }
          }
        }

        dynamic "volume_mounts" {
          for_each = container.value.volume_mounts == null ? [] : container.value.volume_mounts

          content {
            name = volume_mounts.value.name
            path = volume_mounts.value.path
          }
        }
      }
    }

    dynamic "init_container" {
      for_each = each.value.template.init_containers == null ? [] : each.value.template.init_containers

      content {
        args    = init_container.value.args
        command = init_container.value.command
        cpu     = init_container.value.cpu
        image   = init_container.value.image
        memory  = init_container.value.memory
        name    = init_container.value.name

        dynamic "env" {
          for_each = init_container.value.env == null ? [] : init_container.value.env
          content {
            name        = env.value.name
            secret_name = env.value.secret_name
            value       = env.value.value
          }
        }

        dynamic "volume_mounts" {
          for_each = init_container.value.volume_mounts == null ? [] : init_container.value.volume_mounts
          content {
            name = volume_mounts.value.name
            path = volume_mounts.value.path
          }
        }
      }
    }

    dynamic "volume" {
      for_each = each.value.template.volume == null ? [] : each.value.template.volume

      content {
        name         = volume.value.name
        storage_name = volume.value.storage_name
        storage_type = volume.value.storage_type
      }
    }
  }

  dynamic "dapr" {
    for_each = each.value.dapr == null ? [] : [each.value.dapr]

    content {
      app_id       = dapr.value.app_id
      app_port     = dapr.value.app_port
      app_protocol = dapr.value.app_protocol
    }
  }

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "ingress" {
    for_each = each.value.ingress == null ? [] : [each.value.ingress]

    content {
      target_port                = ingress.value.target_port
      allow_insecure_connections = ingress.value.allow_insecure_connections
      external_enabled           = ingress.value.external_enabled
      transport                  = ingress.value.transport

      dynamic "traffic_weight" {
        for_each = ingress.value.traffic_weight == null ? [] : [ingress.value.traffic_weight]

        content {
          percentage      = traffic_weight.value.percentage
          label           = traffic_weight.value.label
          latest_revision = traffic_weight.value.latest_revision
          revision_suffix = traffic_weight.value.revision_suffix
        }
      }

      dynamic "ip_security_restriction" {
        for_each = ingress.value.ip_security_restrictions == null ? [] : ingress.value.ip_security_restrictions
        content {
          action           = ip_security_restriction.value.action
          ip_address_range = ip_security_restriction.value.ip_address_range
          name             = ip_security_restriction.value.name
          description      = ip_security_restriction.value.description
        }
      }
    }
  }

  dynamic "registry" {
    for_each = each.value.registry == null ? [] : each.value.registry

    content {
      server               = registry.value.server
      identity             = registry.value.identity
      password_secret_name = registry.value.password_secret_name
      username             = registry.value.username
    }
  }

  dynamic "secret" {
    for_each = nonsensitive(toset([for pair in lookup(var.container_app_secrets, each.key, []) : pair.name]))

    content {
      name  = secret.key
      value = local.container_app_secrets[each.key][secret.key]
    }
  }
}
