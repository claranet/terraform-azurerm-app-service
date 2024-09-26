output "app_service_slot_name" {
  description = "Name of the App Service slot"
  value       = one(module.staging[*].name)
}

output "app_service_slot_identity_service_principal_id" {
  description = "Id of the Service principal identity of the App Service slot"
  value       = one(module.staging[*].identity_principal_id)
}
