variable "container_app_monitoring_metrics" {
  default     = []
  description = "A list of Container App metric namespaces to monitor if monitoring is enabled"
  type        = list(string)
}

variable "location" {
  description = "The short-format Azure region into which resources will be deployed"
  type        = string
}

variable "log_analytics_workspace_id" {
  default     = null
  description = "The ID of the Log Analytics Workspace to use for diagnostic log and metric collection if enabled"
  type        = string
}

variable "monitoring_logs_container_app" {
  default     = []
  description = "A list of diagnostic log namespaces to monitor for the Container App if enabled"
  type        = list(string)
}

variable "monitoring_metrics_container_app" {
  default     = ["AllMetrics"]
  description = "A list of diagnostic metric namespaces to monitor for the Container App if enabled"
  type        = list(string)
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
  description = "The name of the resource group into which resources will be deployed"
  type        = string
}

variable "resource_suffix" {
  description = "The resource suffix to append to resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z\\d]+(-[a-z\\d]+)*$", var.resource_suffix))
    error_message = "Resource names should use only lowercase characters, numbers, and hyphens."
  }
}

variable "tags" {
  default     = {}
  description = "A collection of tags to assign to taggable resources"
  type        = map(string)
}
