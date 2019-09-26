# Azure App Service Web

This Terraform module creates an [Azure App Service Web](https://docs.microsoft.com/en-us/azure/app-service/overview) 
associated with an [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) 
component and activated [Diagnostics Logs](https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs).

## Limitations

* Diagnostics logs only works fine for Windows for now.
* Untested with App Service slots
* Only one connection string can be set

## Requirements
 
* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.31

## Terraform version compatibility

| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| < 2.x.x        | 0.11.x            |

## Usage

You can use this module by including it this way:

```hcl
module "az-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = var.azure_region
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  location     = module.az-region.location
  client_name  = var.client_name
  environment  = var.environment
  stack        = var.stack
}

resource "azurerm_storage_account" "logs_storage" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = module.az-region.location
  name                     = "appservicelogs"
  resource_group_name      = module.rg.resource_group_name
}

resource "azurerm_storage_container" "logs_storage_container" {
  name                 = "webapps"
  resource_group_name  = module.rg.resource_group_name
  storage_account_name = azurerm_storage_account.logs_storage.name
}

module "app_service_plan" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/app-service-plan.git?ref=vX.X.X"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.az-region.location
  location_short      = module.az-region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  sku = {
    tier = "Standard"
    size = "S1"
  }

  kind = "Linux"
}

module "app_service" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/app-service-web.git?ref=vX.X.X"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.az-region.location
  location_short      = module.az-region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  app_service_plan_id = module.app_service_plan.app_service_plan_id

  app_settings = {
    foo = "bar"
  }

  extra_tags = {
    foo = "bar"
  }

  enable_storage_logging = "true"

  logs_retention                 = "7"
  logs_storage_account_container = "webapps"
  logs_storage_account_name      = azurerm_storage_account.logs_storage.name
  logs_storage_account_rg        = azurerm_storage_account.logs_storage.resource_group_name
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_insights\_custom\_name | Name of the Application Insights, generated if not set. | string | `""` | no |
| app\_service\_custom\_name | Name of the App Service, generated if not set. | string | `""` | no |
| app\_service\_plan\_id | Id of the App Service Plan that hosts the App Service | string | n/a | yes |
| app\_settings | Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings | map | `<map>` | no |
| application\_insights\_type | Application type for Application Insights resource | string | `"Web"` | no |
| client\_affinity\_enabled | Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled | string | `"false"` | no |
| client\_cert\_enabled | Client certificate activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_cert_enabled | string | `"false"` | no |
| client\_name |  | string | n/a | yes |
| connection\_string | Connection string for App Service (could have only one due to Terraform limitation). See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string | map | `<map>` | no |
| enable\_storage\_logging | True to enable sending logs to a blob storage | string | `"true"` | no |
| environment |  | string | n/a | yes |
| extra\_tags | Extra tags to add | map | `<map>` | no |
| https\_only | HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only | string | `"false"` | no |
| location | Azure location for App Service. | string | n/a | yes |
| location\_short | Short string for Azure location. | string | n/a | yes |
| logs\_retention | Logs retention in days | string | `"30"` | no |
| logs\_storage\_account\_container | Name of the container in the Storage Account if storage logging is enabled | string | `"webapps"` | no |
| logs\_storage\_account\_name | Name of the Storage Account if storage logging is enabled | string | `""` | no |
| logs\_storage\_account\_rg | Resource group of the Storage Account if storage logging is enabled | string | `""` | no |
| name\_prefix | Optional prefix for the generated name | string | `""` | no |
| resource\_group\_name |  | string | n/a | yes |
| site\_config | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config | map | `<map>` | no |
| stack |  | string | n/a | yes |

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
| app\_service\_outbound\_ip\_addresses | Outbound IP adresses of the App Service |
| app\_service\_plan\_id | Id of the App Service Plan |
| app\_service\_possible\_outbound\_ip\_addresses | Possible outbound IP adresses of the App Service |
| app\_service\_site\_credential | Site credential block of the App Service |
| app\_service\_source\_control | Source Control information block of the App Service |

## Related documentation

Terraform resource documentation: [https://www.terraform.io/docs/providers/azurerm/r/app_service.html]

Microsoft Azure documentation: [https://docs.microsoft.com/en-us/azure/app-service/overview]
