data "azurerm_client_config" "main" {}

resource "azurerm_app_service" "app_service" {
  name                = local.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  dynamic "site_config" {
    for_each = [merge(local.default_site_config, var.site_config)]

    content {
      always_on                   = lookup(site_config.value, "always_on", null)
      app_command_line            = lookup(site_config.value, "app_command_line", null)
      default_documents           = lookup(site_config.value, "default_documents", null)
      dotnet_framework_version    = lookup(site_config.value, "dotnet_framework_version", null)
      ftps_state                  = lookup(site_config.value, "ftps_state", null)
      health_check_path           = lookup(site_config.value, "health_check_path", null)
      http2_enabled               = lookup(site_config.value, "http2_enabled", null)
      ip_restriction              = concat(local.subnets, local.cidrs, local.service_tags)
      scm_use_main_ip_restriction = var.scm_authorized_ips != [] || var.scm_authorized_subnet_ids != null ? false : true
      scm_ip_restriction          = concat(local.scm_subnets, local.scm_cidrs, local.service_tags)
      java_container              = lookup(site_config.value, "java_container", null)
      java_container_version      = lookup(site_config.value, "java_container_version", null)
      java_version                = lookup(site_config.value, "java_version", null)
      linux_fx_version            = lookup(site_config.value, "linux_fx_version", null)
      local_mysql_enabled         = lookup(site_config.value, "local_mysql_enabled", null)
      managed_pipeline_mode       = lookup(site_config.value, "managed_pipeline_mode", null)
      min_tls_version             = lookup(site_config.value, "min_tls_version", null)
      php_version                 = lookup(site_config.value, "php_version", null)
      python_version              = lookup(site_config.value, "python_version", null)
      remote_debugging_enabled    = lookup(site_config.value, "remote_debugging_enabled", null)
      remote_debugging_version    = lookup(site_config.value, "remote_debugging_version", null)
      scm_type                    = lookup(site_config.value, "scm_type", null)
      use_32_bit_worker_process   = lookup(site_config.value, "use_32_bit_worker_process", null)
      websockets_enabled          = lookup(site_config.value, "websockets_enabled", null)
      windows_fx_version          = lookup(site_config.value, "windows_fx_version", null)

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", [])
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = lookup(cors.value, "support_credentials", null)
        }
      }
    }
  }

  app_settings = merge(local.default_app_settings, var.app_settings)

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }

  auth_settings {
    enabled                        = local.auth_settings.enabled
    issuer                         = local.auth_settings.issuer
    token_store_enabled            = local.auth_settings.token_store_enabled
    unauthenticated_client_action  = local.auth_settings.unauthenticated_client_action
    default_provider               = local.auth_settings.default_provider
    allowed_external_redirect_urls = local.auth_settings.allowed_external_redirect_urls

    dynamic "active_directory" {
      for_each = local.auth_settings_active_directory.client_id == null ? [] : [local.auth_settings_active_directory]
      content {
        client_id         = local.auth_settings_active_directory.client_id
        client_secret     = local.auth_settings_active_directory.client_secret
        allowed_audiences = concat(formatlist("https://%s", [format("%s.azurewebsites.net", local.app_service_name)]), local.auth_settings_active_directory.allowed_audiences)
      }
    }
  }

  client_affinity_enabled = var.client_affinity_enabled
  https_only              = var.https_only
  client_cert_enabled     = var.client_cert_enabled

  identity {
    type = "SystemAssigned"
  }

  dynamic "backup" {
    for_each = var.enable_backup ? [1] : []
    content {
      name                = coalesce(var.backup_custom_name, "DefaultBackup")
      storage_account_url = module.backup_sas_token.storage_account_sas_container_uri

      schedule {
        frequency_interval       = var.backup_frequency_interval
        frequency_unit           = var.backup_frequency_unit
        retention_period_in_days = var.backup_retention_period_in_days
      }
    }
  }

  dynamic "storage_account" {
    for_each = var.mount_points
    content {
      name         = lookup(storage_account.value, "name", format("%s-%s", storage_account.value["account_name"], storage_account.value["share_name"]))
      type         = lookup(storage_account.value, "type", "AzureFiles")
      account_name = lookup(storage_account.value, "account_name", null)
      share_name   = lookup(storage_account.value, "share_name", null)
      access_key   = lookup(storage_account.value, "access_key", null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }

  tags = merge(local.default_tags, var.extra_tags)

  lifecycle {
    ignore_changes = [
      backup[0].storage_account_url,
    ]
  }
}

resource "azurerm_app_service_certificate" "app_service_certificate" {
  for_each = var.custom_domains != null ? {
    for k, v in var.custom_domains :
    k => v if v != null
  } : {}

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  pfx_blob            = contains(keys(each.value), "certificate_file") ? filebase64(each.value.certificate_file) : null
  password            = contains(keys(each.value), "certificate_file") ? each.value.certificate_password : null
  key_vault_secret_id = contains(keys(each.value), "certificate_keyvault_certificate_id") ? each.value.certificate_keyvault_certificate_id : null
}

resource "azurerm_app_service_custom_hostname_binding" "app_service_custom_hostname_binding" {
  for_each = var.custom_domains != null ? var.custom_domains : {}

  hostname            = each.key
  app_service_name    = azurerm_app_service.app_service.name
  resource_group_name = var.resource_group_name
  ssl_state           = lookup(azurerm_app_service_certificate.app_service_certificate, each.key, false) != false ? "SniEnabled" : null
  thumbprint          = lookup(azurerm_app_service_certificate.app_service_certificate, each.key, false) != false ? azurerm_app_service_certificate.app_service_certificate[each.key].thumbprint : null
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_vnet_integration" {
  depends_on     = [azurerm_app_service.app_service]
  count          = var.app_service_vnet_integration_subnet_id == null ? 0 : 1
  app_service_id = azurerm_app_service.app_service.id
  subnet_id      = var.app_service_vnet_integration_subnet_id
}
