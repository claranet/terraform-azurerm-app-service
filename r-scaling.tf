resource "azurerm_monitor_autoscale_setting" "app_scaling" {
  count = "${var.create_default_scaling_rule ? 1 :0}"

  name                = "${local.name_prefix}${var.stack}-${var.client_name}-${var.environment}-scaling"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  target_resource_id = "${module.app_service_plan.app_service_plan_id}"

  profile {
    name = "default"

    capacity {
      default = "${var.instances_count}"
      maximum = "${var.instances_count}"
      minimum = "${var.instances_count}"
    }
  }

  tags = "${merge(local.default_tags, var.extra_tags)}"
}
