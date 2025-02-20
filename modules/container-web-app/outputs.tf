output "service_plan_id" {
  description = "ID of the Service Plan."
  value       = var.service_plan_id
}

output "id" {
  description = "ID of the App Service."
  value       = azurerm_linux_web_app.main.id
}

output "name" {
  description = "Name of the App Service."
  value       = azurerm_linux_web_app.main.name
}

output "resource" {
  description = "Resource output."
  value       = azurerm_linux_web_app.main
}

output "resource_application_insights" {
  description = "Application insights output."
  value       = local.application_insights
}

output "module_diagnostics" {
  description = "Diagnostics Settings module output."
  value       = module.diagnostics
}

output "module_slot" {
  description = "App Service slot output."
  value       = module.staging_slot
}

output "module_backup_sas_token" {
  description = "Backup SAS token module output."
  value       = module.backup_sas_token
}

output "default_site_hostname" {
  description = "The Default Hostname associated with the App Service."
  value       = azurerm_linux_web_app.main.default_hostname
}

output "outbound_ip_addresses" {
  description = "Outbound IP adresses of the App Service."
  value       = split(",", azurerm_linux_web_app.main.outbound_ip_addresses)
}

output "possible_outbound_ip_addresses" {
  description = "Possible outbound IP adresses of the App Service."
  value       = split(",", azurerm_linux_web_app.main.possible_outbound_ip_addresses)
}

output "site_credential" {
  description = "Site credential block of the App Service."
  value       = azurerm_linux_web_app.main.site_credential
}

output "identity_principal_id" {
  description = "ID of the system principal identity of the App Service."
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}

output "certificates_id" {
  description = "ID of certificates generated."
  value       = { for k, v in var.custom_domains : k => azurerm_app_service_certificate.main[k].id if try(v.certificate_id == null, false) }
}

output "application_insights_id" {
  description = "ID of the Application Insights associated to the App Service."
  value       = try(local.application_insights.id, null)
}

output "application_insights_name" {
  description = "Name of the Application Insights associated to the App Service."
  value       = try(local.application_insights.name, null)
}

output "application_insights_app_id" {
  description = "App id of the Application Insights associated to the App Service."
  value       = try(local.application_insights.app_id, null)
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key of the Application Insights associated to the App Service."
  value       = try(local.application_insights.instrumentation_key, null)
  sensitive   = true
}

output "application_insights_application_type" {
  description = "Application Type of the Application Insights associated to the App Service."
  value       = try(local.application_insights.application_type, null)
}

output "slot" {
  description = "Azure App Service slot output object."
  value       = one(module.staging_slot[*].slot)
}

output "slot_name" {
  description = "Name of the App Service slot."
  value       = one(module.staging_slot[*].name)
}

output "slot_identity_principal_id" {
  description = "ID of the system principal identity of the App Service Slot."
  value       = one(module.staging_slot[*].identity_principal_id)
}
