variable "application_insights" {
  description = "Application Insights parameters."
  type = object({
    enabled                               = optional(bool, true)
    id                                    = optional(string, null)
    custom_name                           = optional(string, null)
    type                                  = optional(string, "web")
    daily_data_cap                        = optional(number, null)
    daily_data_cap_notifications_disabled = optional(bool, null)
    retention                             = optional(number, 90)
    internet_ingestion_enabled            = optional(bool, true)
    internet_query_enabled                = optional(bool, true)
    ip_masking_disabled                   = optional(bool, false)
    local_authentication_disabled         = optional(bool, false)
    force_customer_storage_for_profiler   = optional(bool, false)
    log_analytics_workspace_id            = optional(string, null)
    sampling_percentage                   = optional(number, null)
  })
  default = {}
}
