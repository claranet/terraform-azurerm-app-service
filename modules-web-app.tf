module "linux_web_app" {
  count = lower(var.os_type) == "linux" ? 1 : 0

  source = "./modules/linux-web-app"

  client_name         = var.client_name
  environment         = var.environment
  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name
  stack               = var.stack

  name_prefix                     = var.name_prefix
  name_suffix                     = var.name_suffix
  custom_name                     = var.app_service_custom_name
  diagnostic_settings_custom_name = var.diagnostic_settings_custom_name

  service_plan_id = module.service_plan.id

  app_settings       = var.app_settings
  site_config        = var.site_config
  auth_settings      = var.auth_settings
  auth_settings_v2   = var.auth_settings_v2
  connection_strings = var.connection_strings
  sticky_settings    = var.sticky_settings

  mount_points               = var.mount_points
  staging_slot_mount_points  = var.staging_slot_mount_points
  client_affinity_enabled    = var.client_affinity_enabled
  https_only                 = var.https_only
  client_certificate_enabled = var.client_certificate_enabled

  staging_slot_enabled             = var.staging_slot_enabled
  staging_slot_custom_name         = var.staging_slot_custom_name
  staging_slot_custom_app_settings = var.staging_slot_custom_app_settings
  staging_slot_site_config         = var.staging_slot_site_config

  custom_domains = var.custom_domains
  certificates   = var.certificates

  public_network_access_enabled = var.public_network_access_enabled
  allowed_cidrs                 = var.allowed_cidrs
  ip_restriction_headers        = var.ip_restriction_headers
  allowed_subnet_ids            = var.allowed_subnet_ids
  allowed_service_tags          = var.allowed_service_tags
  scm_ip_restriction_headers    = var.scm_ip_restriction_headers
  scm_allowed_cidrs             = var.scm_allowed_cidrs
  scm_allowed_subnet_ids        = var.scm_allowed_subnet_ids
  scm_allowed_service_tags      = var.scm_allowed_service_tags

  vnet_integration_subnet_id = var.vnet_integration_subnet_id
  vnet_image_pull_enabled    = var.vnet_image_pull_enabled

  backup_enabled                   = var.backup_enabled
  backup_custom_name               = var.backup_custom_name
  backup_storage_account_id        = var.backup_storage_account_id
  backup_storage_account_container = var.backup_storage_account_container
  backup_frequency_interval        = var.backup_frequency_interval
  backup_retention_period_in_days  = var.backup_retention_period_in_days
  backup_frequency_unit            = var.backup_frequency_unit
  backup_keep_at_least_one_backup  = var.backup_keep_at_least_one_backup
  backup_token_start_date          = var.backup_token_start_date

  application_insights = var.application_insights

  logs = var.logs

  identity = var.identity

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags
}

moved {
  from = module.linux_web_app["enabled"]
  to   = module.linux_web_app[0]
}

resource "null_resource" "fake_webapp_container_condition" {
  count = lower(var.os_type) == "linuxcontainer" ? 1 : 0

  triggers = {
    webapp_type = var.os_type
  }

  lifecycle {
    precondition {
      condition     = var.docker_image != null
      error_message = "Variable `docker_image` must be set when `os_type` App Service variable is in 'LinuxContainer' mode."
    }
  }
}

module "container_web_app" {
  count = lower(var.os_type) == "linuxcontainer" ? 1 : 0

  source = "./modules/container-web-app"

  client_name         = var.client_name
  environment         = var.environment
  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name
  stack               = var.stack

  name_prefix                     = var.name_prefix
  name_suffix                     = var.name_suffix
  custom_name                     = var.app_service_custom_name
  diagnostic_settings_custom_name = var.diagnostic_settings_custom_name

  service_plan_id = module.service_plan.id

  docker_image = var.docker_image

  app_settings       = var.app_settings
  site_config        = var.site_config
  auth_settings      = var.auth_settings
  auth_settings_v2   = var.auth_settings_v2
  connection_strings = var.connection_strings
  sticky_settings    = var.sticky_settings

  mount_points               = var.mount_points
  staging_slot_mount_points  = var.staging_slot_mount_points
  client_affinity_enabled    = var.client_affinity_enabled
  https_only                 = var.https_only
  client_certificate_enabled = var.client_certificate_enabled

  staging_slot_enabled             = var.staging_slot_enabled
  staging_slot_custom_name         = var.staging_slot_custom_name
  staging_slot_custom_app_settings = var.staging_slot_custom_app_settings
  staging_slot_site_config         = var.staging_slot_site_config

  custom_domains = var.custom_domains
  certificates   = var.certificates

  public_network_access_enabled = var.public_network_access_enabled
  allowed_cidrs                 = var.allowed_cidrs
  ip_restriction_headers        = var.ip_restriction_headers
  allowed_subnet_ids            = var.allowed_subnet_ids
  allowed_service_tags          = var.allowed_service_tags
  scm_ip_restriction_headers    = var.scm_ip_restriction_headers
  scm_allowed_cidrs             = var.scm_allowed_cidrs
  scm_allowed_subnet_ids        = var.scm_allowed_subnet_ids
  scm_allowed_service_tags      = var.scm_allowed_service_tags

  vnet_integration_subnet_id = var.vnet_integration_subnet_id
  vnet_image_pull_enabled    = var.vnet_image_pull_enabled

  backup_enabled                   = var.backup_enabled
  backup_custom_name               = var.backup_custom_name
  backup_storage_account_id        = var.backup_storage_account_id
  backup_storage_account_container = var.backup_storage_account_container
  backup_frequency_interval        = var.backup_frequency_interval
  backup_retention_period_in_days  = var.backup_retention_period_in_days
  backup_frequency_unit            = var.backup_frequency_unit
  backup_keep_at_least_one_backup  = var.backup_keep_at_least_one_backup
  backup_token_start_date          = var.backup_token_start_date

  application_insights = var.application_insights

  logs = var.logs

  identity = var.identity

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags
}

moved {
  from = module.container_web_app["enabled"]
  to   = module.container_web_app[0]
}

module "windows_web_app" {
  count = lower(var.os_type) == "windows" ? 1 : 0

  source = "./modules/windows-web-app"

  client_name         = var.client_name
  environment         = var.environment
  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name
  stack               = var.stack

  name_prefix                     = var.name_prefix
  name_suffix                     = var.name_suffix
  custom_name                     = var.app_service_custom_name
  diagnostic_settings_custom_name = var.diagnostic_settings_custom_name

  service_plan_id = module.service_plan.id

  app_settings       = var.app_settings
  site_config        = var.site_config
  auth_settings      = var.auth_settings
  auth_settings_v2   = var.auth_settings_v2
  connection_strings = var.connection_strings
  sticky_settings    = var.sticky_settings

  mount_points               = var.mount_points
  staging_slot_mount_points  = var.staging_slot_mount_points
  client_affinity_enabled    = var.client_affinity_enabled
  https_only                 = var.https_only
  client_certificate_enabled = var.client_certificate_enabled

  staging_slot_enabled             = var.staging_slot_enabled
  staging_slot_custom_name         = var.staging_slot_custom_name
  staging_slot_custom_app_settings = var.staging_slot_custom_app_settings
  staging_slot_site_config         = var.staging_slot_site_config

  custom_domains = var.custom_domains
  certificates   = var.certificates

  public_network_access_enabled = var.public_network_access_enabled
  allowed_cidrs                 = var.allowed_cidrs
  ip_restriction_headers        = var.ip_restriction_headers
  allowed_subnet_ids            = var.allowed_subnet_ids
  allowed_service_tags          = var.allowed_service_tags
  scm_ip_restriction_headers    = var.scm_ip_restriction_headers
  scm_allowed_cidrs             = var.scm_allowed_cidrs
  scm_allowed_subnet_ids        = var.scm_allowed_subnet_ids
  scm_allowed_service_tags      = var.scm_allowed_service_tags

  vnet_integration_subnet_id = var.vnet_integration_subnet_id

  backup_enabled                   = var.backup_enabled
  backup_custom_name               = var.backup_custom_name
  backup_storage_account_id        = var.backup_storage_account_id
  backup_storage_account_container = var.backup_storage_account_container
  backup_frequency_interval        = var.backup_frequency_interval
  backup_retention_period_in_days  = var.backup_retention_period_in_days
  backup_frequency_unit            = var.backup_frequency_unit
  backup_keep_at_least_one_backup  = var.backup_keep_at_least_one_backup
  backup_token_start_date          = var.backup_token_start_date

  application_insights = var.application_insights

  logs = var.logs

  identity = var.identity

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags
}

moved {
  from = module.windows_web_app["enabled"]
  to   = module.windows_web_app[0]
}
