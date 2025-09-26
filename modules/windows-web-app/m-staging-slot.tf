module "staging_slot" {
  count = var.staging_slot_enabled ? 1 : 0

  source = "../slot"

  environment = var.environment
  stack       = var.stack

  slot_os_type = "Windows"
  name         = local.staging_slot_name
  id           = azurerm_windows_web_app.main.id

  public_network_access_enabled = var.public_network_access_enabled
  vnet_integration_subnet_id    = var.vnet_integration_subnet_id
  ip_restriction                = concat(local.subnets, local.cidrs, local.service_tags)
  scm_ip_restriction            = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)
  scm_allowed_cidrs             = var.scm_allowed_cidrs
  scm_allowed_subnet_ids        = var.scm_allowed_subnet_ids

  site_config                    = local.slot_site_config
  app_settings                   = var.staging_slot_custom_app_settings == null ? local.app_settings : merge(local.default_app_settings, var.staging_slot_custom_app_settings)
  connection_strings             = var.connection_strings
  auth_settings                  = local.auth_settings
  auth_settings_active_directory = local.auth_settings_active_directory
  auth_settings_v2               = local.auth_settings_v2
  auth_settings_v2_login         = local.auth_settings_v2_login

  client_affinity_enabled         = var.client_affinity_enabled
  https_only                      = var.https_only
  key_vault_reference_identity_id = var.key_vault_reference_identity_id
  identity                        = var.identity
  mount_points                    = length(var.staging_slot_mount_points) > 0 ? var.staging_slot_mount_points : var.mount_points
  logs                            = var.logs

  extra_tags = var.extra_tags
}

moved {
  from = module.staging[0].azurerm_windows_web_app_slot.main[0]
  to   = module.staging_slot[0].azurerm_windows_web_app_slot.main[0]
}
