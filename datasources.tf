data "azurerm_subscription" "current_subscription" {
}

data "azurerm_app_service_plan" "plan" {
  name                = local.app_service_plan_name
  resource_group_name = var.resource_group_name
}

module "backup_sas_token" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/storage-sas-token.git?ref=v2.0.0"

  enabled              = var.enable_backup
  resource_group_name  = var.backup_storage_account_rg
  storage_account_name = var.backup_storage_account_name
  storage_container    = var.backup_storage_account_container
}

module "logs_sas_token" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/storage-sas-token.git?ref=v2.0.0"

  enabled              = local.enable_storage_logging
  resource_group_name  = var.logs_storage_account_rg
  storage_account_name = var.logs_storage_account_name
  storage_container    = var.logs_storage_account_container
}
