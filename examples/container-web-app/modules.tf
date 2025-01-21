module "service_plan" {
  source  = "claranet/app-service-plan/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name
  stack               = var.stack

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id,
  ]

  os_type  = "Linux"
  sku_name = "S1"
}

module "container_web_app" {
  source  = "claranet/app-service/azurerm//modules/container-web-app"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name
  stack               = var.stack

  service_plan_id = module.service_plan.id

  app_settings = {
    "DOCKER_ENABLE_CI" = true
    "FOO"              = "bar"
  }

  docker_image = {
    name     = "myapp"
    tag      = "latest"
    registry = "https://${module.acr.acr_fqdn}"
  }

  site_config = {
    http2_enabled = true

    # The "AcrPull" role must be assigned to the managed identity in the target Azure Container Registry
    container_registry_use_managed_identity = true
    # container_registry_managed_identity_client_id = "my_user_assigned_managed_identity_client_id"
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

  authorized_ips     = ["1.2.3.4/32", "4.3.2.1/32"]
  scm_authorized_ips = ["1.2.3.4/32", "4.3.2.1/32"]

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

  application_insights_log_analytics_workspace_id = module.run.log_analytics_workspace_id

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id,
  ]
}

module "acr" {
  source  = "claranet/acr/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name
  sku                 = "Standard"

  azure_services_bypass_allowed = true

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id,
  ]

  extra_tags = {
    foo = "bar"
  }
}

resource "azurerm_role_assignment" "webapp_acr_pull" {
  scope                = module.acr.id
  principal_id         = module.container_web_app.identity_service_principal_id
  role_definition_name = "AcrPull"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_container_registry_webhook" "webhook" {
  name = "webapp${replace(module.container_web_app.name, "/-|_|\\W/", "")}"

  resource_group_name = module.rg.name
  location            = module.azure_region.location

  registry_name = module.acr.acr_name

  service_uri    = "https://${module.container_web_app.site_credential[0].name}:${module.container_web_app.site_credential[0].password}@${module.container_web_app.name}.scm.azurewebsites.net/api/registry/webhook"
  status         = "enabled"
  scope          = "myapp:latest"
  actions        = ["push"]
  custom_headers = {}
}
