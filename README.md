# Azure App Service Web (Linux or Windows)
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/app-service/azurerm/latest)

This Terraform module creates an [Azure Service Plan](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans) using our [dedicated Terraform module](https://registry.terraform.io/modules/claranet/app-service-plan) and creates an [Azure App Service Web](https://docs.microsoft.com/en-us/azure/app-service/overview) (Linux or Windows)
associated with an [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
component and activated [Diagnostics Logs](https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs).

## Limitations

* Diagnostics logs only works fine for Windows for now.
* Untested with App Service slots.
* Using a single certificate file on multiple domains with the `custom_domains` variable is not supported. Use a Key Vault certificate instead.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

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

module "app_service" {
  source  = "claranet/app-service/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
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

    # The "AcrPull" role must be assigned to the managed identity in the target Azure Container Registry
    acr_use_managed_identity_credentials = true
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

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
  ]
}
```

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| container\_web\_app | ./modules/container-web-app | n/a |
| linux\_web\_app | ./modules/linux-web-app | n/a |
| service\_plan | claranet/app-service-plan/azurerm | ~> 6.2.0 |
| windows\_web\_app | ./modules/windows-web-app | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_service\_custom\_name | Name of the App Service, generated if not set. | `string` | `""` | no |
| app\_service\_environment\_id | The ID of the App Service Environment to create this Service Plan in. Requires an Isolated SKU. Use one of I1, I2, I3 for azurerm\_app\_service\_environment, or I1v2, I2v2, I3v2 for azurerm\_app\_service\_environment\_v3 | `string` | `null` | no |
| app\_service\_logs | Configuration of the App Service and App Service Slot logs. [Linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#logs) and [Windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app#logs) documentation. | <pre>object({<br>    detailed_error_messages = optional(bool)<br>    failed_request_tracing  = optional(bool)<br>    application_logs = optional(object({<br>      file_system_level = string<br>      azure_blob_storage = optional(object({<br>        level             = string<br>        retention_in_days = number<br>        sas_url           = string<br>      }))<br>    }))<br>    http_logs = optional(object({<br>      azure_blob_storage = optional(object({<br>        retention_in_days = number<br>        sas_url           = string<br>      }))<br>      file_system = optional(object({<br>        retention_in_days = number<br>        retention_in_mb   = number<br>      }))<br>    }))<br>  })</pre> | `null` | no |
| app\_service\_vnet\_integration\_subnet\_id | Id of the subnet to associate with the app service | `string` | `null` | no |
| app\_settings | Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings | `map(string)` | `{}` | no |
| application\_insights\_custom\_name | Name of the Application Insights, generated if not set. | `string` | `""` | no |
| application\_insights\_enabled | Use Application Insights for this App Service | `bool` | `true` | no |
| application\_insights\_id | ID of the existing Application Insights to use instead of deploying a new one. | `string` | `null` | no |
| application\_insights\_sampling\_percentage | Specifies the percentage of sampled datas for Application Insights. Documentation [here](https://docs.microsoft.com/en-us/azure/azure-monitor/app/sampling#ingestion-sampling) | `number` | `null` | no |
| application\_insights\_type | Application type for Application Insights resource | `string` | `"web"` | no |
| auth\_settings | Authentication settings. Issuer URL is generated thanks to the tenant ID. For active\_directory block, the allowed\_audiences list is filled with a value generated with the name of the App Service. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings | `any` | `{}` | no |
| auth\_settings\_v2 | Authentication settings V2. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2 | `any` | `{}` | no |
| authorized\_ips | IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction | `list(string)` | `[]` | no |
| authorized\_service\_tags | Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction | `list(string)` | `[]` | no |
| authorized\_subnet\_ids | Subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction | `list(string)` | `[]` | no |
| backup\_custom\_name | Custom name for backup | `string` | `null` | no |
| backup\_enabled | `true` to enable App Service backup | `bool` | `false` | no |
| backup\_frequency\_interval | Frequency interval for the App Service backup. | `number` | `1` | no |
| backup\_frequency\_unit | Frequency unit for the App Service backup. Possible values are `Day` or `Hour`. | `string` | `"Day"` | no |
| backup\_keep\_at\_least\_one\_backup | Should the service keep at least one backup, regardless of age of backup. | `bool` | `true` | no |
| backup\_retention\_period\_in\_days | Retention in days for the App Service backup. | `number` | `30` | no |
| backup\_storage\_account\_container | Name of the container in the Storage Account if App Service backup is enabled | `string` | `"webapps"` | no |
| backup\_storage\_account\_name | Storage account name to use if App Service backup is enabled. | `string` | `null` | no |
| backup\_storage\_account\_rg | Storage account resource group to use if App Service backup is enabled. | `string` | `null` | no |
| client\_affinity\_enabled | Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled | `bool` | `false` | no |
| client\_certificate\_enabled | Client certificate activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_certificate_enabled | `bool` | `false` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| connection\_strings | Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string | `list(map(string))` | `[]` | no |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_domains | Custom domains and SSL certificates of the App Service. Could declare a custom domain with SSL binding. SSL certificate could be provided from an Azure Keyvault Certificate Secret or from a file with following attributes :<pre>- certificate_file:                     Path of the certificate file.<br>- certificate_password:                 Certificate password.<br>- certificate_keyvault_certificate_id:  ID of the Azure Keyvault Certificate Secret.<br>- certificate_id:                       ID of an existant certificate.</pre> | <pre>map(object({<br>    certificate_file                    = optional(string)<br>    certificate_password                = optional(string)<br>    certificate_keyvault_certificate_id = optional(string)<br>    certificate_id                      = optional(string)<br>  }))</pre> | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| docker\_image | Docker image to use for this App Service | <pre>object({<br>    name     = string<br>    tag      = string<br>    slot_tag = optional(string)<br>  })</pre> | `null` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| https\_only | HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only | `bool` | `false` | no |
| identity | Map with identity block information. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| ip\_restriction\_headers | IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers | `map(list(string))` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| maximum\_elastic\_worker\_count | The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU. | `number` | `null` | no |
| mount\_points | Storage Account mount points. Name is generated if not set and default type is AzureFiles. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account | `list(map(string))` | `[]` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| os\_type | The O/S type for the App Services to be hosted in this plan. Possible values include `Windows`, `Linux`, and `Container`. | `string` | n/a | yes |
| per\_site\_scaling\_enabled | Should Per Site Scaling be enabled. | `bool` | `false` | no |
| public\_network\_access\_enabled | Whether enable public access for the App Service. | `bool` | `false` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| scm\_authorized\_ips | SCM IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_service\_tags | SCM Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_subnet\_ids | SCM subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_ip\_restriction\_headers | IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers | `map(list(string))` | `null` | no |
| service\_plan\_custom\_name | Name of the App Service Plan, generated if not set. | `string` | `""` | no |
| service\_plan\_extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| site\_config | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block. | `any` | `{}` | no |
| sku\_name | The SKU for the plan. Possible values include B1, B2, B3, D1, F1, FREE, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, and WS3. | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| staging\_slot\_custom\_app\_settings | Override staging slot with custom app settings | `map(string)` | `null` | no |
| staging\_slot\_custom\_name | Custom name of the app service slot | `string` | `null` | no |
| staging\_slot\_enabled | Create a staging slot alongside the app service for blue/green deployment purposes. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_slot | `bool` | `true` | no |
| sticky\_settings | Lists of connection strings and app settings to prevent from swapping between slots. | <pre>object({<br>    app_setting_names       = optional(list(string))<br>    connection_string_names = optional(list(string))<br>  })</pre> | `null` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| worker\_count | The number of Workers (instances) to be allocated. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_service\_container | App Service Container (Container WebApp) output object if Container is choosen. Please refer to `./modules/container-web-app/README.md` |
| app\_service\_linux | App Service Linux (Linux WebApp) output object if Linux is choosen. Please refer to `./modules/linux-web-app/README.md` |
| app\_service\_windows | App Service Windows (Windows WebApp) output object if Windows is choosen. Please refer to `./modules/windows-web-app/README.md` |
| service\_plan | Service Plan output object. Please refer to https://github.com/claranet/terraform-azurerm-app-service-plan/blob/master/README.md#outputs |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/app-service/overview](https://docs.microsoft.com/en-us/azure/app-service/overview)
