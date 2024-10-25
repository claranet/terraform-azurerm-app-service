module "staging" {
  count = var.staging_slot_enabled ? 1 : 0

  source = "../slot"

  environment = var.environment
  stack       = var.stack

  slot_os_type   = "Windows"
  slot_name      = local.staging_slot_name
  app_service_id = azurerm_windows_web_app.app_service_windows.id

  public_network_access_enabled          = var.public_network_access_enabled
  app_service_vnet_integration_subnet_id = var.app_service_vnet_integration_subnet_id
  ip_restriction                         = concat(local.subnets, local.cidrs, local.service_tags)
  scm_ip_restriction                     = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)
  scm_authorized_ips                     = var.scm_authorized_ips
  scm_authorized_subnet_ids              = var.scm_authorized_subnet_ids

  site_config                    = local.staging_slot_site_config
  app_settings                   = var.staging_slot_custom_app_settings == null ? local.app_settings : merge(local.default_app_settings, var.staging_slot_custom_app_settings)
  connection_strings             = local.staging_connection_strings
  auth_settings                  = local.auth_settings
  auth_settings_active_directory = local.auth_settings_active_directory
  auth_settings_v2               = local.auth_settings_v2
  auth_settings_v2_login         = local.auth_settings_v2_login

  client_affinity_enabled = var.client_affinity_enabled
  https_only              = var.https_only
  identity                = var.identity
  mount_points            = length(var.staging_slot_mount_points) > 0 ? var.staging_slot_mount_points : var.mount_points
  app_service_logs        = var.app_service_logs

  extra_tags = var.extra_tags
}

moved {
  from = azurerm_windows_web_app_slot.app_service_windows_slot[0]
  to   = module.staging[0].app_service_windows_slot.main[0]
}
