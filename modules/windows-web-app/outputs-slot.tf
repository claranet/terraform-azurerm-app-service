output "slot" {
  description = "Azure App Service slot output object."
  value       = one(module.staging[*].slot)
}

output "app_service_slot_name" {
  description = "Name of the App Service slot."
  value       = one(module.staging[*].name)
}

output "app_service_slot_identity_service_principal_id" {
  description = "ID of the Service principal identity of the App Service slot."
  value       = one(module.staging[*].identity_principal_id)
}
