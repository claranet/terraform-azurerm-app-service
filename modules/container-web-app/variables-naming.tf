# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

# Custom naming override
variable "custom_name" {
  description = "Name of the App Service, generated if not set."
  type        = string
  default     = ""
}

variable "application_insights_custom_name" {
  description = "Name of the Application Insights, generated if not set."
  type        = string
  default     = ""
}

variable "staging_slot_custom_name" {
  description = "Custom name of the app service slot."
  type        = string
  default     = null
}

variable "backup_custom_name" {
  description = "Custom name for backup."
  type        = string
  default     = null
}
