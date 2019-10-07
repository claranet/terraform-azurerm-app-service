data "azurerm_subscription" "current_subscription" {
}

data "azurerm_storage_account" "backup_storage_account" {
  count = var.enable_backup == "true" ? 1 : 0

  name                = var.backup_storage_account_name
  resource_group_name = var.backup_storage_account_rg
}

module "backup_sas_token" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/storage-sas-token.git?ref=AZ-122-first-version"

  enabled              = var.enable_backup == "true"
  resource_group_name  = var.backup_storage_account_rg
  storage_account_name = var.backup_storage_account_name
  storage_container    = var.backup_storage_account_container
}

data "azurerm_storage_account" "logs_storage_account" {
  count = var.enable_storage_logging == "true" ? 1 : 0

  name                = var.logs_storage_account_name
  resource_group_name = var.logs_storage_account_rg
}

module "logs_sas_token" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/storage-sas-token.git?ref=AZ-122-first-version"

  enabled              = var.enable_storage_logging == "true"
  resource_group_name  = var.logs_storage_account_rg
  storage_account_name = var.logs_storage_account_name
  storage_container    = var.logs_storage_account_container
}
