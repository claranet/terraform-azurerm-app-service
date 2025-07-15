variable "app_settings" {
  description = "Application settings for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings)."
  type        = map(string)
  default     = {}
}

variable "site_config" {
  description = "Site config for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config). IP restriction attribute is no more managed in this block."
  type        = any
  default     = {}
}

variable "connection_strings" {
  description = "Connection strings for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string)."
  type        = list(map(string))
  default     = []
}

variable "sticky_settings" {
  description = "Lists of connection strings and app settings to prevent from swapping between slots."
  type = object({
    app_setting_names       = optional(list(string))
    connection_string_names = optional(list(string))
  })
  default = null
}

variable "allowed_cidrs" {
  description = "IPs restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction)."
  type        = list(string)
  default     = []
}

variable "public_network_access_enabled" {
  description = "Whether enable public access for the App Service."
  type        = bool
  default     = false
}

variable "allowed_subnet_ids" {
  description = "Subnets restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction)."
  type        = list(string)
  default     = []
}

variable "allowed_service_tags" {
  description = "Service Tags restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction)."
  type        = list(string)
  default     = []
}

variable "ip_restriction_headers" {
  description = "IPs restriction headers for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers)."
  type        = map(list(string))
  default     = null
}

variable "scm_allowed_cidrs" {
  description = "SCM IPs restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction)."
  type        = list(string)
  default     = []
}

variable "scm_allowed_subnet_ids" {
  description = "SCM subnets restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction)."
  type        = list(string)
  default     = []
}

variable "scm_allowed_service_tags" {
  description = "SCM Service Tags restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction)."
  type        = list(string)
  default     = []
}

variable "scm_ip_restriction_headers" {
  description = "IPs restriction headers for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers)."
  type        = map(list(string))
  default     = null
}

variable "client_affinity_enabled" {
  description = "Client affinity activation for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled)."
  type        = bool
  default     = false
}

variable "https_only" {
  description = "HTTPS restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only)."
  type        = bool
  default     = true
}

variable "client_certificate_enabled" {
  description = "Client certificate activation for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_certificate_enabled)."
  type        = bool
  default     = false
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

variable "staging_slot_mount_points" {
  description = "Storage Account mount points for staging slot. Name is generated if not set and default type is `AzureFiles`. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account)."
  type = list(object({
    name         = optional(string)
    type         = optional(string, "AzureFiles")
    account_name = string
    share_name   = string
    access_key   = string
    mount_path   = optional(string)
  }))
  validation {
    condition     = alltrue([for m in var.staging_slot_mount_points : contains(["AzureBlob", "AzureFiles"], m.type)])
    error_message = "The `type` attribute of `var.staging_slot_mount_points` object list must be `AzureBlob` or `AzureFiles`."
  }
  default  = []
  nullable = false
}

variable "auth_settings" {
  description = "Authentication settings. Issuer URL is generated thanks to the tenant ID. For `active_directory` block, the `allowed_audiences` list is filled with a value generated with the name of the App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings)."
  type        = any
  default     = {}
}

variable "auth_settings_v2" {
  description = "Authentication settings V2. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2)."
  type        = any
  default     = {}
}

variable "custom_domains" {
  description = <<EOD
Custom domains and SSL certificates of the App Service. Could declare a custom domain with SSL binding. SSL certificate could be provided from an Azure Keyvault Certificate Secret or from a file with following attributes :
```
- certificate_name:                     Name of the stored certificate.
- certificate_keyvault_certificate_id:  ID of the Azure Keyvault Certificate Secret.
```
EOD
  type = map(object({
    certificate_name                    = optional(string)
    certificate_keyvault_certificate_id = optional(string)
    certificate_thumbprint              = optional(string)
  }))
  default  = {}
  nullable = false
}

variable "certificates" {
  description = "Certificates for custom domains"
  type        = map(map(string))
  default     = {}
}

variable "vnet_integration_subnet_id" {
  description = "ID of the subnet to associate with the App Service."
  type        = string
  default     = null
}

variable "staging_slot_enabled" {
  type        = bool
  description = "Create a staging slot alongside the App Service for blue/green deployment purposes. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_slot)."
  default     = true
}

variable "staging_slot_custom_app_settings" {
  type        = map(string)
  description = "Override staging slot with custom app settings."
  default     = null
}

variable "staging_slot_site_config" {
  description = "Staging slot site config for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config)."
  type        = any
  default     = {}
  nullable    = false
}

variable "docker_image" {
  description = "Docker image to use for this App Service."
  type = object({
    registry          = optional(string)
    name              = string
    tag               = string
    registry_username = optional(string)
    registry_password = optional(string)
    slot_name         = optional(string)
    slot_tag          = optional(string)
  })
  default = null
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


variable "vnet_image_pull_enabled" {
  description = "Controls whether container image pull traffic is routed through the virtual network."
  type        = bool
  default     = false
}
