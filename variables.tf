variable "container_app_environment" {
  type = object({
    name                = string
    resource_group_name = string
  })
  default     = null
  description = "Reference to existing container apps environment to use."

  validation {
    condition     = var.container_app_environment == null ? true : var.container_app_environment.name != null && var.container_app_environment.resource_group_name != null
    error_message = "`name` and `resource_group_name` cannot be null"
  }
}

variable "container_app_environment_internal_load_balancer_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Should the Container Environment operate in Internal Load Balancing Mode? Defaults to `false`. Changing this forces a new resource to be created."
}

variable "container_app_environment_infrastructure_subnet_id" {
  type        = string
  default     = null
  description = "(Optional) The existing subnet to use for the container apps control plane. Changing this forces a new resource to be created."
}

variable "container_app_environment_name" {
  type        = string
  description = "The name of the container apps managed environment. Changing this forces a new resource to be created."
  nullable    = false
}

variable "container_apps" {
  type = map(object({
    name                  = string
    tags                  = optional(map(string))
    revision_mode         = string
    workload_profile_name = optional(string)

    template = object({
      init_containers = optional(set(object({
        args    = optional(list(string))
        command = optional(list(string))
        cpu     = optional(number)
        image   = string
        name    = string
        memory  = optional(string)
        env = optional(list(object({
          name        = string
          secret_name = optional(string)
          value       = optional(string)
        })))
        volume_mounts = optional(list(object({
          name = string
          path = string
        })))
      })), [])
      containers = set(object({
        name    = string
        image   = string
        args    = optional(list(string))
        command = optional(list(string))
        cpu     = string
        memory  = string
        env = optional(set(object({
          name        = string
          secret_name = optional(string)
          value       = optional(string)
        })))
        liveness_probe = optional(object({
          failure_count_threshold = optional(number)
          header = optional(object({
            name  = string
            value = string
          }))
          host             = optional(string)
          initial_delay    = optional(number, 1)
          interval_seconds = optional(number, 10)
          path             = optional(string)
          port             = number
          timeout          = optional(number, 1)
          transport        = string
        }))
        readiness_probe = optional(object({
          failure_count_threshold = optional(number)
          header = optional(object({
            name  = string
            value = string
          }))
          host                    = optional(string)
          interval_seconds        = optional(number, 10)
          path                    = optional(string)
          port                    = number
          success_count_threshold = optional(number, 3)
          timeout                 = optional(number)
          transport               = string
        }))
        startup_probe = optional(object({
          failure_count_threshold = optional(number)
          header = optional(object({
            name  = string
            value = string
          }))
          host             = optional(string)
          interval_seconds = optional(number, 10)
          path             = optional(string)
          port             = number
          timeout          = optional(number)
          transport        = string
        }))
        volume_mounts = optional(list(object({
          name = string
          path = string
        })))
      }))
      max_replicas    = optional(number)
      min_replicas    = optional(number)
      revision_suffix = optional(string)

      volume = optional(set(object({
        name         = string
        storage_name = optional(string)
        storage_type = optional(string)
      })))
    })

    ingress = optional(object({
      allow_insecure_connections = optional(bool, false)
      external_enabled           = optional(bool, false)
      ip_security_restrictions = optional(list(object({
        action           = string
        ip_address_range = string
        name             = string
        description      = optional(string)
      })), [])
      target_port = number
      transport   = optional(string)
      traffic_weight = object({
        label           = optional(string)
        latest_revision = optional(string)
        revision_suffix = optional(string)
        percentage      = number
      })
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    dapr = optional(object({
      app_id       = string
      app_port     = number
      app_protocol = optional(string)
    }))

    registry = optional(list(object({
      server               = string
      username             = optional(string)
      password_secret_name = optional(string)
      identity             = optional(string)
    })))
  }))
  description = "The container apps to deploy."
  nullable    = false

  validation {
    condition     = length(var.container_apps) >= 1
    error_message = "At least one container should be provided."
  }
  validation {
    condition     = alltrue([for n, c in var.container_apps : c.ingress == null ? true : (c.ingress.ip_security_restrictions == null ? true : (length(distinct([for r in c.ingress.ip_security_restrictions : r.action])) <= 1))])
    error_message = "The `action` types in an all `ip_security_restriction` blocks must be the same for the `ingress`, mixing `Allow` and `Deny` rules is not currently supported by the service."
  }
}

variable "container_app_diagnostic_category" {
  default = {
    log    = []
    metric = ["AllMetrics"]
  }
  description = "The diagnostic category for the Container apps."
  type = object({
    log    = list(string)
    metric = list(string)
  })
}

variable "container_app_secrets" {
  type = map(list(object({
    name  = string
    value = string
  })))
  default     = {}
  description = "(Optional) The secrets of the container apps. The key of the map should be aligned with the corresponding container app."
  nullable    = false
  sensitive   = true
}

variable "location" {
  type        = string
  description = "(Required) The location this container app is deployed in. This should be the same as the environment in which it is deployed."
  nullable    = false
}

variable "log_analytics_workspace_id" {
  default     = null
  description = "The ID of the Log Analytics Workspace to use for diagnostic log and metric collection if enabled"
  type        = string
}

variable "monitoring_enabled" {
  default     = false
  description = "Determines if monitoring should be enabled for the ADLS Storage Account"
  type        = bool
}

variable "private_networking_enabled" {
  default     = false
  description = "Determines if the a private endpoint will be provisioned for the ADLS Storage Account"
  type        = bool
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which the resources will be created."
  nullable    = false
}

variable "tags" {
  default     = {}
  description = "A collection of tags to assign to taggable resources"
  type        = map(string)
}
