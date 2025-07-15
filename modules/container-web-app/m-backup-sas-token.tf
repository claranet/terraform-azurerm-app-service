module "backup_sas_token" {
  source  = "claranet/storage-sas-token/azurerm"
  version = "~> 8.2.0"

  count = var.backup_enabled ? 1 : 0

  expiration_start_date = coalesce(var.backup_token_start_date, time_static.main.rfc3339)
  token_type            = "service"

  service_token_service_name = var.backup_storage_account_container
  service_token_service_type = "blob"
  storage_account_id         = var.backup_storage_account_id
  permissions                = ["read", "list", "write", "append", "create", "delete"]
}

resource "time_static" "main" {}
