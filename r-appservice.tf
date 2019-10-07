resource "azurerm_app_service" "app_service" {
  name                = local.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  dynamic "site_config" {
    for_each = [merge(local.default_site_config, var.site_config)]

    content {
      always_on                 = lookup(site_config.value, "always_on", null)
      app_command_line          = lookup(site_config.value, "app_command_line", null)
      default_documents         = lookup(site_config.value, "default_documents", null)
      dotnet_framework_version  = lookup(site_config.value, "dotnet_framework_version", null)
      ftps_state                = lookup(site_config.value, "ftps_state", null)
      http2_enabled             = lookup(site_config.value, "http2_enabled", null)
      ip_restriction            = concat(local.subnets, local.cidrs)
      java_container            = lookup(site_config.value, "java_container", null)
      java_container_version    = lookup(site_config.value, "java_container_version", null)
      java_version              = lookup(site_config.value, "java_version", null)
      linux_fx_version          = lookup(site_config.value, "linux_fx_version", null)
      local_mysql_enabled       = lookup(site_config.value, "local_mysql_enabled", null)
      managed_pipeline_mode     = lookup(site_config.value, "managed_pipeline_mode", null)
      min_tls_version           = lookup(site_config.value, "min_tls_version", null)
      php_version               = lookup(site_config.value, "php_version", null)
      python_version            = lookup(site_config.value, "python_version", null)
      remote_debugging_enabled  = lookup(site_config.value, "remote_debugging_enabled", null)
      remote_debugging_version  = lookup(site_config.value, "remote_debugging_version", null)
      scm_type                  = lookup(site_config.value, "scm_type", null)
      use_32_bit_worker_process = lookup(site_config.value, "use_32_bit_worker_process", null)
      virtual_network_name      = lookup(site_config.value, "virtual_network_name", null)
      websockets_enabled        = lookup(site_config.value, "websockets_enabled", null)
      windows_fx_version        = lookup(site_config.value, "windows_fx_version", null)

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

  client_affinity_enabled = var.client_affinity_enabled
  https_only              = var.https_only
  client_cert_enabled     = var.client_cert_enabled

  identity {
    type = "SystemAssigned"
  }

  dynamic "logs" {
    for_each = var.enable_storage_logging == "true" ? list("fake") : []
    content {
      application_logs {
        azure_blob_storage {
          level             = var.logs_level
          retention_in_days = var.logs_retention
          sas_url           = module.logs_sas_token.storage_account_sas_container_uri
        }
      }
      http_logs {
        azure_blob_storage {
          retention_in_days = var.logs_retention
          sas_url           = module.logs_sas_token.storage_account_sas_container_uri
        }
      }
    }
  }

  dynamic "backup" {
    for_each = var.enable_backup == "true" ? list("fake") : []
    content {
      name                = coalesce(var.backup_custom_name, "DefaultBackup")
      storage_account_url = module.backup_sas_token.storage_account_sas_container_uri

      schedule {
        frequency_interval = var.backup_frequency_interval
        frequency_unit     = var.backup_frequency_unit
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
}
