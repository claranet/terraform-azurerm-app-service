locals {
  default_site_config = {
    always_on               = "true"
    scm_minimum_tls_version = "1.2"
  }

  default_slot_site_config = {
    always_on               = "true"
    scm_minimum_tls_version = "1.2"
    application_stack = {
      docker_image_name        = format("%s:%s", coalesce(var.docker_image.slot_name, var.docker_image.name), coalesce(var.docker_image.slot_tag, var.docker_image.tag))
      docker_registry_url      = var.docker_image.registry
      docker_registry_username = var.docker_image.registry_username
      docker_registry_password = var.docker_image.registry_password
    }
  }

  site_config      = merge(local.default_site_config, var.site_config)
  slot_site_config = merge(local.default_slot_site_config, var.site_config, var.staging_slot_site_config)

  id = "/subscriptions/${data.azurerm_subscription.main.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Web/sites/${local.name}"

  application_insights = try(data.azurerm_application_insights.main[0], try(azurerm_application_insights.main[0], {}))

  default_app_settings = var.application_insights.enabled ? {
    APPLICATION_INSIGHTS_IKEY             = try(local.application_insights.instrumentation_key, "")
    APPINSIGHTS_INSTRUMENTATIONKEY        = try(local.application_insights.instrumentation_key, "")
    APPLICATIONINSIGHTS_CONNECTION_STRING = try(local.application_insights.connection_string, "")
  } : {}

  app_settings = merge(local.default_app_settings, var.app_settings)

  default_ip_restrictions_headers = {
    x_azure_fdid      = null
    x_fd_health_probe = null
    x_forwarded_for   = null
    x_forwarded_host  = null
  }

  ip_restriction_headers = var.ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.ip_restriction_headers)] : []

  cidrs = [for cidr in var.allowed_cidrs : {
    name                      = "ip_restriction_cidr_${join("", [1, index(var.allowed_cidrs, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.allowed_cidrs, cidr)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  subnets = [for subnet in var.allowed_subnet_ids : {
    name                      = "ip_restriction_subnet_${join("", [1, index(var.allowed_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.allowed_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  service_tags = [for service_tag in var.allowed_service_tags : {
    name                      = "service_tag_restriction_${join("", [1, index(var.allowed_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    subnet_id                 = null
    priority                  = join("", [1, index(var.allowed_service_tags, service_tag)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  scm_ip_restriction_headers = var.scm_ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.scm_ip_restriction_headers)] : []

  scm_cidrs = [for cidr in var.scm_allowed_ips : {
    name                      = "scm_ip_restriction_cidr_${join("", [1, index(var.scm_allowed_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.scm_allowed_ips, cidr)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  scm_subnets = [for subnet in var.scm_allowed_subnet_ids : {
    name                      = "scm_ip_restriction_subnet_${join("", [1, index(var.scm_allowed_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.scm_allowed_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  scm_service_tags = [for service_tag in var.scm_allowed_service_tags : {
    name                      = "scm_service_tag_restriction_${join("", [1, index(var.scm_allowed_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    subnet_id                 = null
    priority                  = join("", [1, index(var.scm_allowed_service_tags, service_tag)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  auth_settings = merge(
    {
      enabled                        = false
      issuer                         = format("https://sts.windows.net/%s/", data.azurerm_client_config.main.tenant_id)
      token_store_enabled            = false
      unauthenticated_client_action  = "RedirectToLoginPage"
      default_provider               = "AzureActiveDirectory"
      allowed_external_redirect_urls = []
      active_directory               = null
    },
  var.auth_settings)

  auth_settings_active_directory = merge(
    {
      client_id         = null
      client_secret     = null
      allowed_audiences = []
    },
  local.auth_settings.active_directory == null ? local.auth_settings_ad_default : var.auth_settings.active_directory)

  auth_settings_ad_default = {
    client_id         = null
    client_secret     = null
    allowed_audiences = []
  }

  auth_settings_v2 = merge({
    auth_enabled = false
  }, var.auth_settings_v2)

  auth_settings_v2_login_default = {
    token_store_enabled               = false
    token_refresh_extension_time      = 72
    preserve_url_fragments_for_logins = false
    cookie_expiration_convention      = "FixedTime"
    cookie_expiration_time            = "08:00:00"
    validate_nonce                    = true
    nonce_expiration_time             = "00:05:00"
  }

  auth_settings_v2_login = try(var.auth_settings_v2.login, local.auth_settings_v2_login_default)
}
