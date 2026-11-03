module "backup_sas_token" {
  source  = "claranet/storage-sas-token/azurerm"
  version = "~> 9.0"

  count = var.backup_enabled ? 1 : 0

  expiration_start_date        = coalesce(var.backup_token_start_date, timeadd(time_static.main[0].rfc3339, "-15m"))
  expiration_duration_in_hours = var.backup_token_expiration_in_hours
  token_type                   = "service"

  service_token_service_name = var.backup_storage_account_container
  service_token_service_type = "container"
  storage_account_id         = var.backup_storage_account_id
  permissions                = ["read", "add", "create", "write", "delete", "list"]
}

resource "time_static" "main" {
  count = var.backup_enabled ? 1 : 0
}
