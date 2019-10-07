variable "client_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "stack" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  description = "Azure location for App Service."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
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

variable "app_insights_custom_name" {
  description = "Name of the Application Insights, generated if not set."
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "application_insights_type" {
  description = "Application type for Application Insights resource"
  type        = string
  default     = "Web"
}

variable "enable_storage_logging" {
  description = "\"true\" to enable sending logs to a blob storage"
  type        = bool
  default     = true
}

variable "logs_retention" {
  description = "Logs retention in days"
  type        = string
  default     = "30"
}

variable "logs_level" {
  description = "Logs level. Can be Error, Warning, Information, Verbose and Off"
  type        = string
  default     = "Warning"
}

variable "logs_storage_account_name" {
  description = "Name of the Storage Account if storage logging is enabled"
  type        = string
  default     = ""
}

variable "logs_storage_account_rg" {
  description = "Resource group of the Storage Account if storage logging is enabled"
  type        = string
  default     = ""
}

variable "logs_storage_account_container" {
  description = "Name of the container in the Storage Account if storage logging is enabled"
  type        = string
  default     = "webapps"
}

variable "app_settings" {
  description = "Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings"
  type        = map(string)
  default     = {}
}

variable "site_config" {
  description = "Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block."
  type        = map(string)
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
