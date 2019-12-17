locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  default_site_config = {
    always_on = "true"
  }

  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  app_service_id = "/subscriptions/${data.azurerm_subscription.current_subscription.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Web/sites/${local.app_service_name}"
  app_service_name = coalesce(
    var.app_service_custom_name,
    "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-web"
  )

  app_insights_name = coalesce(
    var.app_insights_custom_name,
    "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-ai"
  )

  default_app_settings = {
    "APPLICATION_INSIGHTS_IKEY"      = azurerm_application_insights.app_insights.instrumentation_key
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.app_insights.instrumentation_key
  }

  app_service_plan_name = split("/", var.app_service_plan_id)[8]

  cidrs = [for cidr in var.authorized_ips : {
    ip_address                = split("/", cidr)[0]
    subnet_mask               = cidrnetmask(cidr)
    virtual_network_subnet_id = null
  }]

  subnets = [for subnet in var.authorized_subnet_ids : {
    ip_address                = null
    subnet_mask               = null
    virtual_network_subnet_id = subnet
  }]

  auth_settings = merge(
    {
      enabled          = false
      active_directory = []
    },
  var.auth_settings)
}
