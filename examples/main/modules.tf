resource "azurerm_storage_account" "assets_storage" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = module.azure_region.location
  name                     = "appserviceassets"
  resource_group_name      = module.rg.name
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_share" "assets_share" {
  name               = "assets"
  storage_account_id = azurerm_storage_account.assets_storage.id
  quota              = 50
}

module "app_service" {
  source  = "claranet/app-service/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name
  stack               = var.stack

  os_type  = "Linux"
  sku_name = "B2"

  app_settings = {
    FOO = "bar"
  }

  site_config = {
    application_stack = {
      php_version = "8.2"
    }

    http2_enabled = true

    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"
  }

  auth_settings = {
    enabled             = true
    token_store_enabled = true

    active_directory = {
      client_id         = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      client_secret     = "xxxxxxxxxxxxxxxxxxxxx"
      allowed_audiences = ["https://www.example.com"]
    }
  }

  custom_domains = {
    # Custom domain with SSL certificate file
    "example.com" = {
      certificate_file     = "./example.com.pfx"
      certificate_password = "xxxxxxxxx"
    }
    # Custom domain with SSL certificate stored in a keyvault
    "example2.com" = {
      certificate_keyvault_certificate_id = var.certificate_keyvault_id
    }
    # Custom domain without SSL certificate
    "example3.com" = null
    # Custom domain with an existant SSL certificate
    "exemple4.com" = {
      certificate_id = var.certificate_id
    }
  }

  allowed_cidrs = ["1.2.3.4/32", "4.3.2.1/32"]

  ip_restriction_headers = {
    x_forwarded_host = ["myhost1.fr", "myhost2.fr"]
  }
  scm_ip_restriction_headers = {
    x_forwarded_host = ["myhost1.fr", "myhost2.fr"]
  }

  staging_slot_custom_app_settings = {
    John = "Doe"
  }

  extra_tags = {
    foo = "bar"
  }

  mount_points = [
    {
      account_name = azurerm_storage_account.assets_storage.name
      share_name   = azurerm_storage_share.assets_share.name
      access_key   = azurerm_storage_account.assets_storage.primary_access_key
      mount_path   = "/var/www/html/assets"
    }
  ]

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id,
  ]
}
