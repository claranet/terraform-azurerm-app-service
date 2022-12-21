data "azurerm_subscription" "current_subscription" {
}

data "azurerm_client_config" "main" {}

data "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0

  name                = split("/", var.application_insights_id)[8]
  resource_group_name = split("/", var.application_insights_id)[4]
}

data "azurerm_app_service_certificate" "certificate" {
  for_each = var.custom_domains != null ? {
    for k, v in var.custom_domains :
    k => v if try(v.certificate_id != null, false)
  } : {}

  name                = reverse(split("/", each.value.certificate_id))[0]
  resource_group_name = var.resource_group_name
}

module "backup_sas_token" {
  source  = "claranet/storage-sas-token/azurerm"
  version = "2.0.0"

  enabled              = var.backup_enabled
  resource_group_name  = var.backup_storage_account_rg
  storage_account_name = var.backup_storage_account_name
  storage_container    = var.backup_storage_account_container
}
