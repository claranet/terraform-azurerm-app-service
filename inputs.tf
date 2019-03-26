variable "client_name" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "stack" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "location" {
  description = "Azure location for App Service."
  type        = "string"
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = "string"
}

variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = "string"
  default     = ""
}

variable "plan_custom_name" {
  description = "Name of the App Service Plan, generated if not set."
  type        = "string"
  default     = ""
}

variable "app_service_custom_name" {
  description = "Name of the App Service, generated if not set."
  type        = "string"
  default     = ""
}

variable "app_insights_custom_name" {
  description = "Name of the Application Insights, generated if not set."
  type        = "string"
  default     = ""
}

variable "plan_sku" {
  description = "A sku block for App Service Plan. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service_plan.html#sku"
  type        = "map"
}

variable "kind" {
  description = "The kind of the App Service Plan to create. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service_plan.html#kind"
  type        = "string"
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = "map"
  default     = {}
}

variable "reserved_plan" {
  description = "Is the App Service Plan is Reserved."
  type        = "string"
  default     = "false"
}

variable "application_insights_type" {
  description = "Application type for Application Insights resource"
  type        = "string"
  default     = "Web"
}

variable "logs_destination" {
  description = "Logs destination for App Service, can be `storage_account`, `log_analytics` or `none`"
  type        = "string"
}

variable "logs_retention" {
  description = "Logs retention in days"
  type        = "string"
  default     = "30"
}

variable "logs_storage_account_name" {
  description = "Name of the Storage Account for log storage if `logs_destination` is `storage_account`"
  type        = "string"
  default     = ""
}

variable "logs_storage_account_rg" {
  description = "Resource group of the Storage Account for log storage if `logs_destination` is `storage_account`"
  type        = "string"
  default     = ""
}

variable "logs_storage_account_container" {
  description = "Name of the container in the Storage Account for log storage if `logs_destination` is `storage_account`"
  type        = "string"
  default     = "webapps"
}

variable "logs_log_analytics_workspace_id" {
  description = "Id of the Log Analytics Workspace for log storage if `logs_destination` is `log_analytics`"
  type        = "string"
  default     = ""
}

variable "app_settings" {
  description = "Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings"
  type        = "map"
  default     = {}
}

variable "site_config" {
  description = "Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config"
  type        = "map"
  default     = {}
}

variable "connection_string" {
  description = "Connection string for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string"
  type        = "list"
  default     = []
}

variable "client_affinity_enabled" {
  description = "Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled"
  type        = "string"
  default     = "false"
}

variable "client_cert_enabled" {
  description = "Client certificate activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_cert_enabled"
  type        = "string"
  default     = "false"
}

variable "https_only" {
  description = "HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only"
  type        = "string"
  default     = "false"
}

variable "create_default_scaling_rule" {
  description = "True to create a default sclaing rune that allows to have high availability with more than one App Service Plan instance."
  type        = "string"
  default     = "true"
}

variable "instances_count" {
  description = "Instances count for App Service if `create_default_scaling_rule` set to true"
  type        = "string"
  default     = "2"
}
