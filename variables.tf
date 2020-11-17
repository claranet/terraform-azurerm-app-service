variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "app_service_plan_id" {
  description = "Id of the App Service Plan that hosts the App Service"
  type        = string
}

variable "app_service_custom_name" {
  description = "Name of the App Service, generated if not set."
  type        = string
  default     = ""
}

variable "diag_settings_custom_name" {
  description = "Custom name of the diagnostics settings, generated if not set."
  type        = string
  default     = ""
}

variable "app_insights_custom_name" {
  description = "Name of the Application Insights, generated if not set."
  type        = string
  default     = ""
}

variable "app_insights_instrumentation_key" {
  description = "Use another application insight instead of deploying a new one."
  type        = string
  default     = null
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "application_insights_type" {
  description = "Application type for Application Insights resource"
  type        = string
  default     = "web"
}

variable "enable_logging" {
  description = "Boolean flag to specify whether logging is enabled"
  type        = bool
  default     = true
}

variable "logs_storage_retention" {
  description = "Retention in days for logs on Storage Account"
  type        = string
  default     = "30"
}

variable "logs_storage_account_id" {
  description = "Storage Account id for logs"
  type        = string
  default     = null
}

variable "logs_log_analytics_workspace_id" {
  description = "Log Analytics Workspace id for logs"
  type        = string
  default     = null
}

variable "app_settings" {
  description = "Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings"
  type        = map(string)
  default     = {}
}

variable "site_config" {
  description = "Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block."
  type        = any
  default     = {}
}

variable "connection_strings" {
  description = "Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string"
  type        = list(map(string))
  default     = []
}

variable "authorized_ips" {
  description = "IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "authorized_subnet_ids" {
  description = "Subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "authorized_service_tags" {
  description = "Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_authorized_ips" {
  description = "SCM IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_authorized_subnet_ids" {
  description = "SCM subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_authorized_service_tags" {
  description = "SCM Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "client_affinity_enabled" {
  description = "Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled"
  type        = string
  default     = "false"
}

variable "client_cert_enabled" {
  description = "Client certificate activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_cert_enabled"
  type        = string
  default     = "false"
}

variable "https_only" {
  description = "HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only"
  type        = string
  default     = "false"
}

variable "enable_backup" {
  description = "\"true\" to enable App Service backup"
  type        = bool
  default     = false
}

variable "backup_frequency_interval" {
  description = "Frequency interval for the App Service backup."
  type        = number
  default     = 1
}

variable "backup_frequency_unit" {
  description = "Frequency unit for the App Service backup. Possible values are Day or Hour."
  type        = string
  default     = "Day"
}

variable "backup_storage_account_name" {
  description = "Storage account name to use if App Service backup is enabled."
  type        = string
  default     = null
}

variable "backup_storage_account_rg" {
  description = "Storage account resource group to use if App Service backup is enabled."
  type        = string
  default     = null
}

variable "backup_storage_account_container" {
  description = "Name of the container in the Storage Account if App Service backup is enabled"
  type        = string
  default     = "webapps"
}

variable "backup_custom_name" {
  description = "Custom name for backup"
  type        = string
  default     = null
}

variable "mount_points" {
  description = "Storage Account mount points. Name is generated if not set and default type is AzureFiles. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account"
  type        = list(map(string))
  default     = []
}

variable "auth_settings" {
  description = "Authentication settings. Issuer URL is generated thanks to the tenant ID. For active_directory block, the allowed_audiences list is filled with a value generated with the name of the App Service. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings"
  type        = any
  default     = {}
}

variable "custom_domains" {
  description = "Custom domains and SSL certificates of the App Service. Could declare a custom domain with SSL binding. SSL certificate could be provided from an Azure Keyvault Certificate Secret or from a file."
  type        = map(map(string))
  default     = null
}

variable "app_service_vnet_integration_subnet_id" {
  description = "Id of the subnet to associate with the app service"
  type        = string
  default     = null
}
