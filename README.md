# Azure App Service Web
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/app-service-web/azurerm/)

This Terraform module creates an [Azure App Service Web](https://docs.microsoft.com/en-us/azure/app-service/overview) 
associated with an [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) 
component and activated [Diagnostics Logs](https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs).

## Limitations

* Diagnostics logs only works fine for Windows for now.
* Untested with App Service slots

## Requirements
 
* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.34

## Terraform version compatibility

| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| < 2.x.x        | 0.11.x            |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location     = module.azure-region.location
  client_name  = var.client_name
  environment  = var.environment
  stack        = var.stack
}

resource "azurerm_storage_account" "logs_storage" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = module.azure-region.location
  name                     = "appservicelogs"
  resource_group_name      = module.rg.resource_group_name
}

resource "azurerm_storage_container" "logs_storage_container" {
  name                 = "webapps"
  resource_group_name  = module.rg.resource_group_name
  storage_account_name = azurerm_storage_account.logs_storage.name
}

resource "azurerm_storage_account" "assets_storage" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = module.azure-region.location
  name                     = "appserviceassets"
  resource_group_name      = module.rg.resource_group_name
}

resource "azurerm_storage_share" "assets_share" {
  name                 = "assets"
  storage_account_name = azurerm_storage_account.assets_storage.name
  quota                = 50
}

module "app_service_plan" {
  source  = "claranet/app-service-plan/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  sku = {
    tier = "Standard"
    size = "S1"
  }

  kind = "Linux"
}

module "app_service" {
  source  = "claranet/app-service-web/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  app_service_plan_id = module.app_service_plan.app_service_plan_id

  app_settings = {
    foo = "bar"
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

  logs_storage_account_id = azurerm_storage_account.logs_storage.id
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| app\_insights\_custom\_name | Name of the Application Insights, generated if not set. | `string` | `""` | no |
| app\_service\_custom\_name | Name of the App Service, generated if not set. | `string` | `""` | no |
| app\_service\_plan\_id | Id of the App Service Plan that hosts the App Service | `string` | n/a | yes |
| app\_settings | Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings | `map(string)` | `{}` | no |
| application\_insights\_type | Application type for Application Insights resource | `string` | `"Web"` | no |
| auth\_settings | Authentication settings. Issuer URL is generated thanks to the tenant ID. For active\_directory block, the allowed\_audiences list is filled with a value generated with the name of the App Service. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings | `any` | `{}` | no |
| authorized\_ips | IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction | `list(string)` | `[]` | no |
| authorized\_subnet\_ids | Subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction | `list(string)` | `[]` | no |
| backup\_custom\_name | Custom name for backup | `string` | n/a | yes |
| backup\_frequency\_interval | Frequency interval for the App Service backup. | `number` | `1` | no |
| backup\_frequency\_unit | Frequency unit for the App Service backup. Possible values are Day or Hour. | `string` | `"Day"` | no |
| backup\_storage\_account\_container | Name of the container in the Storage Account if App Service backup is enabled | `string` | `"webapps"` | no |
| backup\_storage\_account\_name | Storage account name to use if App Service backup is enabled. | `string` | n/a | yes |
| backup\_storage\_account\_rg | Storage account resource group to use if App Service backup is enabled. | `string` | n/a | yes |
| client\_affinity\_enabled | Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled | `string` | `"false"` | no |
| client\_cert\_enabled | Client certificate activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_cert_enabled | `string` | `"false"` | no |
| client\_name | n/a | `string` | n/a | yes |
| connection\_strings | Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string | `list(map(string))` | `[]` | no |
| enable\_backup | "true" to enable App Service backup | `bool` | `false` | no |
| enable\_logging | Boolean flag to specify whether logging is enabled | `bool` | `true` | no |
| environment | n/a | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| https\_only | HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only | `string` | `"false"` | no |
| location | Azure location for App Service. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_log\_analytics\_workspace\_id | Log Analytics Workspace id for logs | `string` | n/a | yes |
| logs\_storage\_account\_id | Storage Account id for logs | `string` | n/a | yes |
| logs\_storage\_retention | Retention in days for logs on Storage Account | `string` | `"30"` | no |
| mount\_points | Storage Account mount points. Name is generated if not set and default type is AzureFiles. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account | `list(map(string))` | `[]` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| resource\_group\_name | n/a | `string` | n/a | yes |
| site\_config | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block. | `map(string)` | `{}` | no |
| stack | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| app\_insights\_app\_id | App id of the Application Insights associated to the App Service |
| app\_insights\_application\_type | Application Type of the Application Insights associated to the App Service |
| app\_insights\_id | Id of the Application Insights associated to the App Service |
| app\_insights\_instrumentation\_key | Instrumentation key of the Application Insights associated to the App Service |
| app\_insights\_name | Name of the Application Insights associated to the App Service |
| app\_service\_default\_site\_hostname | The Default Hostname associated with the App Service |
| app\_service\_id | Id of the App Service |
| app\_service\_identity\_service\_principal\_id | Id of the Service principal identity of the App Service |
| app\_service\_name | Name of the App Service |
| app\_service\_outbound\_ip\_addresses | Outbound IP adresses of the App Service |
| app\_service\_plan\_id | Id of the App Service Plan |
| app\_service\_possible\_outbound\_ip\_addresses | Possible outbound IP adresses of the App Service |
| app\_service\_site\_credential | Site credential block of the App Service |
| app\_service\_source\_control | Source Control information block of the App Service |

## Related documentation

Terraform resource documentation: [www.terraform.io/docs/providers/azurerm/r/app_service.html](https://www.terraform.io/docs/providers/azurerm/r/app_service.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/app-service/overview](https://docs.microsoft.com/en-us/azure/app-service/overview)
