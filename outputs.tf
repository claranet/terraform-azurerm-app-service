output "app_service_plan_id" {
  description = "Id of the App Service Plan"
  value       = "${var.app_service_plan_id}"
}

output "app_service_id" {
  description = "Id of the App Service"
  value       = "${azurerm_app_service.app_service.id}"
}

output "app_service_default_site_hostname" {
  description = "The Default Hostname associated with the App Service"
  value       = "${azurerm_app_service.app_service.default_site_hostname}"
}

output "app_service_outbound_ip_addresses" {
  description = "Outbound IP adresses of the App Service"
  value       = "${split(",", azurerm_app_service.app_service.outbound_ip_addresses)}"
}

output "app_service_possible_outbound_ip_addresses" {
  description = "Possible outbound IP adresses of the App Service"
  value       = "${split(",", azurerm_app_service.app_service.possible_outbound_ip_addresses)}"
}

output "app_service_source_control" {
  description = "Source Control information block of the App Service"
  value       = "${azurerm_app_service.app_service.source_control}"
}

output "app_service_site_credential" {
  description = "Site credential block of the App Service"
  value       = "${azurerm_app_service.app_service.site_credential}"
}

output "app_service_identity" {
  description = "Idenity block of the App Service"
  value       = "${azurerm_app_service.app_service.identity}"
}

output "app_insights_id" {
  description = "Id of the Application Insights associated to the App Service"
  value       = "${azurerm_application_insights.app_insights.id}"
}

output "app_insights_name" {
  description = "Name of the Application Insights associated to the App Service"
  value       = "${azurerm_application_insights.app_insights.name}"
}

output "app_insights_app_id" {
  description = "App id of the Application Insights associated to the App Service"
  value       = "${azurerm_application_insights.app_insights.app_id}"
}

output "app_insights_instrumentation_key" {
  description = "Instrumentation key of the Application Insights associated to the App Service"
  value       = "${azurerm_application_insights.app_insights.instrumentation_key}"
}

output "app_insights_application_type" {
  description = "Application Type of the Application Insights associated to the App Service"
  value       = "${azurerm_application_insights.app_insights.application_type}"
}
