locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  app_service_name  = coalesce(var.app_service_custom_name, azurecaf_name.app_service_web.name)
  staging_slot_name = coalesce(var.staging_slot_custom_name, var.use_caf_naming ? azurecaf_name.app_service_staging_slot.name : "staging-slot")

  app_insights_name = coalesce(var.application_insights_custom_name, azurecaf_name.application_insights.name)

  backup_name = coalesce(var.backup_custom_name, "DefaultBackup")
}
