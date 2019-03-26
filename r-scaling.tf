# TODO more setings through vars
resource "azurerm_monitor_autoscale_setting" "app_scaling" {
  name                = "${local.name_prefix}${var.stack}-${var.client_name}-${var.environment}-scaling"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  target_resource_id = "${module.app_service_plan.app_service_plan_id}"

  profile {
    capacity {
      default = 2
      maximum = 2
      minimum = 1
    }

    name = "default"
  }

  tags = "${merge(local.default_tags, var.extra_tags)}"
}
