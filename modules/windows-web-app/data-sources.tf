data "azurerm_subscription" "main" {
}

moved {
  from = data.azurerm_subscription.current_subscription
  to   = data.azurerm_subscription.main
}

data "azurerm_client_config" "main" {}

data "azurerm_application_insights" "main" {
  count = var.application_insights.enabled && var.application_insights.id != null ? 1 : 0

  name                = split("/", var.application_insights.id)[8]
  resource_group_name = split("/", var.application_insights.id)[4]
}

moved {
  from = data.azurerm_application_insights.app_insights
  to   = data.azurerm_application_insights.main
}
