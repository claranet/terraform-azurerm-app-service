# Azure App Service slot
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/slot/azurerm/)

Azure module to deploy an Azure App Service slot.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](../../CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

resource "azurerm_storage_account" "assets_storage" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = module.azure_region.location
  name                     = "appserviceassets"
  resource_group_name      = module.rg.resource_group_name
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_share" "assets_share" {
  name                 = "assets"
  storage_account_name = azurerm_storage_account.assets_storage.name
  quota                = 50
}

module "service_plan" {
  source  = "claranet/app-service-plan/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
  ]

  os_type  = "Linux"
  sku_name = "S1"
}

module "linux_web_app" {
  source  = "claranet/app-service/azurerm//modules/linux-web-app"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  service_plan_id = module.service_plan.service_plan_id

  app_settings = {
    FOO = "bar"
  }

  site_config = {
    http2_enabled = true
    # The "AcrPull" role must be assigned to the managed identity in the target Azure Container Registry
    acr_use_managed_identity_credentials = true

    application_stack = {
      php_version = "8.2"
    }
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

  authorized_ips = ["1.2.3.4/32", "4.3.2.1/32"]

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

  application_insights_log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
  ]
}

module "testing_slot" {
  source  = "claranet/app-service/azurerm//modules/slot"
  version = "x.x.x"

  environment = var.environment
  stack       = var.stack

  slot_os_type   = "Linux"
  slot_name      = "testing-slot"
  app_service_id = module.linux_web_app.app_service_id

  public_network_access_enabled = true

  app_settings = {
    FOO = "testing"
  }

  mount_points = [
    {
      account_name = azurerm_storage_account.assets_storage.name
      share_name   = azurerm_storage_share.assets_share.name
      access_key   = azurerm_storage_account.assets_storage.primary_access_key
      mount_path   = "/var/www/html/assets"
    }
  ]

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_web_app_slot.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app_slot) | resource |
| [azurerm_windows_web_app_slot.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app_slot) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_settings | Application settings for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings). | `map(string)` | `{}` | no |
| auth\_settings | Authentication settings. Issuer URL is generated thanks to the tenant ID. For `active_directory block`, the `allowed_audiences` list is filled with a value generated with the name of the App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings). | `any` | `{}` | no |
| auth\_settings\_active\_directory | Active Directory settings. The `allowed_audiences` list is filled with a value generated with the name of the App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings). | `any` | `{}` | no |
| auth\_settings\_v2 | Authentication settings V2. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2). | `any` | `{}` | no |
| auth\_settings\_v2\_login | Values for the authentication settings V2 login block. | `any` | `{}` | no |
| client\_affinity\_enabled | Client affinity activation for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled). | `bool` | `false` | no |
| connection\_strings | Connection strings for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string). | `list(map(string))` | `[]` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add on resources. | `map(string)` | `{}` | no |
| https\_only | HTTPS restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only). | `bool` | `false` | no |
| id | The ID of the App Service to create the slot for. | `string` | n/a | yes |
| identity | Map with identity block information. | <pre>object({<br/>    type         = string<br/>    identity_ids = list(string)<br/>  })</pre> | <pre>{<br/>  "identity_ids": [],<br/>  "type": "SystemAssigned"<br/>}</pre> | no |
| ip\_restriction | IP restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction). | `any` | `{}` | no |
| logs | Configuration of the App Service and App Service slot logs. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#logs). | <pre>object({<br/>    detailed_error_messages = optional(bool)<br/>    failed_request_tracing  = optional(bool)<br/>    application_logs = optional(object({<br/>      file_system_level = string<br/>      azure_blob_storage = optional(object({<br/>        level             = string<br/>        retention_in_days = number<br/>        sas_url           = string<br/>      }))<br/>    }))<br/>    http_logs = optional(object({<br/>      azure_blob_storage = optional(object({<br/>        retention_in_days = number<br/>        sas_url           = string<br/>      }))<br/>      file_system = optional(object({<br/>        retention_in_days = number<br/>        retention_in_mb   = number<br/>      }))<br/>    }))<br/>  })</pre> | `null` | no |
| mount\_points | Storage Account mount points. Name is generated if not set and default type is `AzureFiles`. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account). | <pre>list(object({<br/>    name         = optional(string)<br/>    type         = optional(string, "AzureFiles")<br/>    account_name = string<br/>    share_name   = string<br/>    access_key   = string<br/>    mount_path   = optional(string)<br/>  }))</pre> | `[]` | no |
| name | Azure App Service slot name. | `string` | n/a | yes |
| public\_network\_access\_enabled | Whether the Azure App Service slot is available from public network. | `bool` | `false` | no |
| scm\_allowed\_ips | SCM IPs restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction). | `list(string)` | `[]` | no |
| scm\_allowed\_subnet\_ids | SCM subnets restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction). | `list(string)` | `[]` | no |
| scm\_ip\_restriction | SCM IP restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction). | `any` | `{}` | no |
| site\_config | Site config for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block). | `any` | `{}` | no |
| slot\_os\_type | The O/S type for the App Services slot. Possible values include `Windows`, `Linux`, and `Container`. | `string` | n/a | yes |
| stack | Project stack name. | `string` | n/a | yes |
| vnet\_integration\_subnet\_id | ID of the subnet to associate with the App Service slot. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Azure App Service slot ID. |
| identity\_principal\_id | Azure App Service slot system identity principal ID. |
| name | Azure App Service slot name. |
| slot | Azure App Service slot output object. |
<!-- END_TF_DOCS -->
