variable "slot_os_type" {
  description = "The O/S type for the App Services slot. Possible values include `Windows`, `Linux`, and `Container`."
  type        = string
}

variable "id" {
  description = "The ID of the App Service to create the slot for."
  type        = string
}

variable "site_config" {
  description = "Site config for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block)."
  type        = any
  default     = {}
}

variable "app_settings" {
  description = "Application settings for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings)."
  type        = map(string)
  default     = {}
}

variable "connection_strings" {
  description = "Connection strings for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string)."
  type        = list(map(string))
  default     = []
}

variable "auth_settings" {
  description = "Authentication settings. Issuer URL is generated thanks to the tenant ID. For `active_directory block`, the `allowed_audiences` list is filled with a value generated with the name of the App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings)."
  type        = any
  default     = {}
}

variable "auth_settings_v2" {
  description = "Authentication settings V2. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2)."
  type        = any
  default     = {}
}

variable "auth_settings_v2_login" {
  description = "Values for the authentication settings V2 login block."
  type        = any
  default     = {}

}

variable "auth_settings_active_directory" {
  description = "Active Directory settings. The `allowed_audiences` list is filled with a value generated with the name of the App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings)."
  type        = any
  default     = {}
}

variable "client_affinity_enabled" {
  description = "Client affinity activation for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled)."
  type        = bool
  default     = false
}

variable "https_only" {
  description = "HTTPS restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only)."
  type        = bool
  default     = false
}

variable "identity" {
  description = "Map with identity block information."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

variable "mount_points" {
  description = "Storage Account mount points. Name is generated if not set and default type is `AzureFiles`. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account)."
  type = list(object({
    name         = optional(string)
    type         = optional(string, "AzureFiles")
    account_name = string
    share_name   = string
    access_key   = string
    mount_path   = optional(string)
  }))
  validation {
    condition     = alltrue([for m in var.mount_points : contains(["AzureBlob", "AzureFiles"], m.type)])
    error_message = "The `type` attribute of `var.mount_points` object list must be `AzureBlob` or `AzureFiles`."
  }
  default  = []
  nullable = false
}

variable "logs" {
  description = "Configuration of the App Service and App Service slot logs. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#logs)."
  type = object({
    detailed_error_messages = optional(bool)
    failed_request_tracing  = optional(bool)
    application_logs = optional(object({
      file_system_level = string
      azure_blob_storage = optional(object({
        level             = string
        retention_in_days = number
        sas_url           = string
      }))
    }))
    http_logs = optional(object({
      azure_blob_storage = optional(object({
        retention_in_days = number
        sas_url           = string
      }))
      file_system = optional(object({
        retention_in_days = number
        retention_in_mb   = number
      }))
    }))
  })
  default = null
}

variable "vnet_image_pull_enabled" {
  description = "Should the traffic for the image pull be routed over virtual network enabled."
  type        = bool
  default     = false
}
