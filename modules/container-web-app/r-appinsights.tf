resource "azurerm_application_insights" "main" {
  count = var.application_insights.enabled && var.application_insights.id == null ? 1 : 0

  name = local.application_insights_name

  location            = var.location
  resource_group_name = var.resource_group_name

  workspace_id     = var.application_insights.log_analytics_workspace_id
  application_type = var.application_insights.type

  daily_data_cap_in_gb                  = var.application_insights.daily_data_cap
  daily_data_cap_notifications_disabled = var.application_insights.daily_data_cap_notifications_disabled
  sampling_percentage                   = var.application_insights.sampling_percentage

  retention_in_days = var.application_insights.retention

  internet_ingestion_enabled = var.application_insights.internet_ingestion_enabled
  internet_query_enabled     = var.application_insights.internet_query_enabled
  disable_ip_masking         = var.application_insights.ip_masking_disabled

  local_authentication_disabled       = var.application_insights.local_authentication_disabled
  force_customer_storage_for_profiler = var.application_insights.force_customer_storage_for_profiler

  tags = merge(
    local.default_tags,
    var.extra_tags,
    {
      format("hidden-link:%s", local.id) = "Resource"
    },
  )

  lifecycle {
    precondition {
      condition     = var.application_insights.enabled && var.application_insights.log_analytics_workspace_id != null
      error_message = "var.application_insights.log_analytics_workspace_id is mandatory when Application Insights is enabled."
    }
  }
}

moved {
  from = azurerm_application_insights.app_insights
  to   = azurerm_application_insights.main
}
