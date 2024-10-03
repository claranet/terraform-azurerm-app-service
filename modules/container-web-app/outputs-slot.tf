output "slot" {
  description = "Azure App Service slot output object"
  value       = one(module.staging[*].slot)
}

output "app_service_slot_name" {
  description = "Name of the App Service slot"
  value       = try(module.staging[0].name, null)
}

output "app_service_slot_identity_service_principal_id" {
  description = "Id of the Service principal identity of the App Service slot"
  value       = try(module.staging[0].identity_principal_id, null)
}
