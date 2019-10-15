data "azurerm_subscription" "current_subscription" {
}

data "azurerm_storage_account" "logs_storage_account" {
  name                = var.logs_storage_account_name
  resource_group_name = var.logs_storage_account_rg

  count = var.enable_storage_logging ? 1 : 0
}

data "template_file" "log_config_none" {
  template = file(format("%s/files/log_config_none.json.tpl", path.module))
}

data "template_file" "log_config_storage" {
  template = file(format("%s/files/log_config_storage.json.tpl", path.module))

  vars = {
    storage_account_name      = var.logs_storage_account_name
    storage_account_container = var.logs_storage_account_container
    logs_retention            = var.logs_retention
  }
}
