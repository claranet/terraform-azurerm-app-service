resource "azurerm_application_insights" "app_insights" {
  name                = "${local.app_insights_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  application_type = "Web"

  tags = "${merge(local.default_tags, var.extra_tags)}"

  lifecycle {
    ignore_changes = [
      "tags.hidden-link",
    ]
  }
}

# App Insights tagging is done here to avoid any circular dependency
module "appinsights_tagging" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/helpers/tagging.git?ref=AZ-64-tagging"

  resource_id = "${azurerm_application_insights.app_insights.id}"
  tags        = "${map(format("hidden-link:%s", azurerm_app_service.app_service.id), "Resource")}"
  behavior    = "merge"
}
