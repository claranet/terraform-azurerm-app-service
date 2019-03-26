# Custom code waiting for this issue implementation https://github.com/terraform-providers/terraform-provider-azurerm/issues/1082
# Works only for Windows
resource "null_resource" "logging_activation" {
  provisioner "local-exec" {
    command = <<CMD
      sas_token=$(az storage container generate-sas --name ${var.logs_storage_account_container} --connection-string "${data.azurerm_storage_account.logs_storage_account.primary_connection_string}" --output tsv --permissions rwdl --expiry 2032-01-01)
      token=$(az account get-access-token --subscription ${data.azurerm_subscription.current_subscription.subscription_id} --output tsv --query '@.accessToken')
      curl -XPUT --silent -H "Authorization: Bearer $token" -H "Content-Type: application/json" --data "${replace(data.template_file.log_config.rendered, "\"", "\\\"")}" https://management.azure.com/subscriptions/${data.azurerm_subscription.current_subscription.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Web/sites/${azurerm_app_service.app_service.name}/config/logs?api-version=2016-08-01
    CMD
  }

  depends_on = ["azurerm_app_service.app_service"]
}
