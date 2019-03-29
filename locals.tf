locals {
  default_tags = {
    env   = "${var.environment}"
    stack = "${var.stack}"
  }

  default_site_config = {
    always_on = "true"
  }

  name_prefix = "${var.name_prefix != "" ? "${var.name_prefix}-" : ""}"

  app_service_name = "${coalesce(var.app_service_custom_name, "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-web")}"
  app_service_id   = "/subscriptions/${data.azurerm_subscription.current_subscription.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Web/sites/${local.app_service_name}"

  app_insights_name = "${coalesce(var.app_insights_custom_name, "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-ai")}"

  default_app_settings = {
    "APPLICATION_INSIGHTS_IKEY"            = "${azurerm_application_insights.app_insights.instrumentation_key}"
    "APPINSIGHTS_INSTRUMENTATIONKEY"       = "${azurerm_application_insights.app_insights.instrumentation_key}"
    "DIAGNOSTICS_AZUREBLOBRETENTIONINDAYS" = "${var.logs_retention}"
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS"   = "${var.logs_retention}"
  }
}
