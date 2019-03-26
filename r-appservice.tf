resource "azurerm_app_service" "app_service" {
  name                = "${local.app_service_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  app_service_plan_id = "${module.app_service_plan.app_service_plan_id}"

  site_config = ["${merge(local.default_site_config, var.site_config)}"]

  app_settings = "${merge(local.default_app_settings, var.app_settings)}"

  connection_string = "${var.connection_string}"

  client_affinity_enabled = "${var.client_affinity_enabled}"
  https_only              = "${var.https_only}"
  client_cert_enabled     = "${var.client_cert_enabled}"

  tags = "${merge(local.default_tags, var.extra_tags)}"

  lifecycle {
    ignore_changes = [
      "app_settings.%",
      "app_settings.DIAGNOSTICS_AZUREBLOBCONTAINERSASURL",
      "app_settings.DIAGNOSTICS_AZUREBLOBRETENTIONINDAYS",
      "app_settings.WEBSITE_HTTPLOGGING_CONTAINER_URL",
      "app_settings.WEBSITE_HTTPLOGGING_RETENTION_DAYS",
    ]
  }
}
