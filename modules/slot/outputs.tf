output "slot" {
  description = "Azure App Service slot output object"
  value       = one(azurerm_linux_web_app_slot.main[*])
}

output "id" {
  description = "Azure App Service slot ID"
  value       = one(azurerm_linux_web_app_slot.main[*].id)
}

output "name" {
  description = "Azure App Service slot name"
  value       = one(azurerm_linux_web_app_slot.main[*].name)
}

output "identity_principal_id" {
  description = "Azure App Service slot system identity principal ID"
  value       = try(azurerm_linux_web_app_slot.main[0].identity[0].principal_id, null)
}
