# Backup options

variable "backup_enabled" {
  description = "`true` to enable App Service backup."
  type        = bool
  default     = false
}

variable "backup_frequency_interval" {
  description = "Frequency interval for the App Service backup."
  type        = number
  default     = 1
}

variable "backup_retention_period_in_days" {
  description = "Retention in days for the App Service backup."
  type        = number
  default     = 30
}

variable "backup_frequency_unit" {
  description = "Frequency unit for the App Service backup. Possible values are `Day` or `Hour`."
  type        = string
  default     = "Day"
}

variable "backup_keep_at_least_one_backup" {
  description = "Should the service keep at least one backup, regardless of age of backup."
  type        = bool
  default     = true
}

variable "backup_storage_account_id" {
  description = "Storage account ID to use if App Service backup is enabled."
  type        = string
  default     = null
}

variable "backup_storage_account_container" {
  description = "Name of the container in the Storage Account if App Service backup is enabled."
  type        = string
  default     = "webapps"
}

variable "backup_token_start_date" {
  description = "Start date for the backup SAS token, as an RFC3339 timestamp. Defaults to 15 minutes before the first apply, to absorb clock skew. Change it to generate a new token."
  type        = string
  default     = null
}

variable "backup_token_expiration_in_hours" {
  description = "Validity duration, in hours, of the backup SAS token, counted from its generation. Defaults to 2 years. The token is not renewed automatically: change `backup_token_start_date` to generate a new one before it expires."
  type        = number
  default     = 17520
  nullable    = false

  validation {
    condition     = var.backup_token_expiration_in_hours > 0 && floor(var.backup_token_expiration_in_hours) == var.backup_token_expiration_in_hours
    error_message = "`backup_token_expiration_in_hours` must be a whole number of hours greater than 0."
  }
}
