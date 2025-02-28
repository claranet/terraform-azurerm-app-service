module "backup_sas_token" {
  source  = "claranet/storage-sas-token/azurerm"
  version = "~> 8.0.0"

  count = var.backup_enabled ? 1 : 0

  storage_account_connection_string = var.backup_storage_account_connection_string
  storage_container                 = var.backup_storage_account_container
}
