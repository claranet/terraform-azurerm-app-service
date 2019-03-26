module "app_service_plan" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/app-service-plan.git?ref=AZ-64-remove-pinned-provider-version"

  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  location_short      = "${var.location_short}"

  custom_name = "${var.plan_custom_name}"
  name_prefix = "${var.name_prefix}"

  sku = "${var.plan_sku}"

  kind = "${var.kind}"

  extra_tags = "${merge(local.default_tags, var.extra_tags)}"
}
