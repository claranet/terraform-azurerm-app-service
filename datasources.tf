data "azurerm_subscription" "current_subscription" {}

data "azurerm_storage_account" "logs_storage_account" {
  name                = "${var.logs_storage_account_name}"
  resource_group_name = "${var.logs_storage_account_rg}"
}

data "template_file" "log_config" {
  template = "${file(format("%s/files/log_config.json.tpl", path.module))}"

  vars {
    storage_account_name      = "${data.azurerm_storage_account.logs_storage_account.name}"
    storage_account_container = "${var.logs_storage_account_container}"
    logs_retention            = "${var.logs_retention}"
  }
}
