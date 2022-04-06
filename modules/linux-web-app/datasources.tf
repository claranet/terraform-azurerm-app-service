data "azurerm_subscription" "current_subscription" {
}

module "backup_sas_token" {
  source  = "claranet/storage-sas-token/azurerm"
  version = "2.0.0"

  enabled              = var.enable_backup
  resource_group_name  = var.backup_storage_account_rg
  storage_account_name = var.backup_storage_account_name
  storage_container    = var.backup_storage_account_container
}
