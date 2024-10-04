data "azurerm_subscription" "current_subscription" {
}

data "azurerm_client_config" "main" {}

data "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0

  name                = split("/", var.application_insights_id)[8]
  resource_group_name = split("/", var.application_insights_id)[4]
}

module "backup_sas_token" {
  source  = "claranet/storage-sas-token/azurerm"
  version = "7.0.1"

  count = var.backup_enabled ? 1 : 0

  storage_account_connection_string = var.backup_storage_account_connection_string
  storage_container                 = var.backup_storage_account_container
}
