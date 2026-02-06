# Azure App Service - Windows Web App
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](../../CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](../../NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](../../LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/app-service/azurerm/latest/submodules/windows-web-app)

This Terraform module creates an [Azure App Service Web (Windows)](https://docs.microsoft.com/en-us/azure/app-service/overview)
associated with an [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
component and activated [Diagnostics Logs](https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs).

## Limitations

* Diagnostics logs only works fine for Windows for now.
* Untested with App Service slots.
* Using a single certificate file on multiple domains with the `custom_domains` variable is not supported. Use a Key Vault certificate instead.

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

  os_type  = "Windows"
  sku_name = "S1"
}

module "windows_web_app" {
  source  = "claranet/app-service/azurerm//modules/windows-web-app"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name
  stack               = var.stack

  service_plan_id = module.service_plan.id

  app_settings = {
    FOO = "bar"
  }

  site_config = {
    http2_enabled = true

    application_stack = {
      current_stack  = "dotnet"
      dotnet_version = "v8.0"
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

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id,
  ]
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | >= 1.2.28 |
| azurerm | ~> 4.0 |
| time | ~> 0.13 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| backup\_sas\_token | claranet/storage-sas-token/azurerm | ~> 8.2.0 |
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 8.2.0 |
| staging\_slot | ../slot | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_certificate.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate) | resource |
| [azurerm_app_service_custom_hostname_binding.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_application_insights.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_windows_web_app.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app) | resource |
| [time_static.main](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurecaf_name.app_service_web](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.application_insights](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurerm_application_insights.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_cidrs | IPs restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction). | `list(string)` | `[]` | no |
| allowed\_service\_tags | Service Tags restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction). | `list(string)` | `[]` | no |
| allowed\_subnet\_ids | Subnets restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction). | `list(string)` | `[]` | no |
| app\_settings | Application settings for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings). | `map(string)` | `{}` | no |
| application\_insights | Application Insights parameters. | <pre>object({<br/>    enabled                               = optional(bool, true)<br/>    id                                    = optional(string, null)<br/>    custom_name                           = optional(string, null)<br/>    type                                  = optional(string, "web")<br/>    daily_data_cap                        = optional(number, null)<br/>    daily_data_cap_notifications_disabled = optional(bool, null)<br/>    retention                             = optional(number, 90)<br/>    internet_ingestion_enabled            = optional(bool, true)<br/>    internet_query_enabled                = optional(bool, true)<br/>    ip_masking_disabled                   = optional(bool, false)<br/>    local_authentication_disabled         = optional(bool, false)<br/>    force_customer_storage_for_profiler   = optional(bool, false)<br/>    log_analytics_workspace_id            = optional(string, null)<br/>    sampling_percentage                   = optional(number, null)<br/>  })</pre> | `{}` | no |
| application\_insights\_custom\_name | Name of the Application Insights, generated if not set. | `string` | `""` | no |
| auth\_settings | Authentication settings. Issuer URL is generated thanks to the tenant ID. For `active_directory` block, the `allowed_audiences` list is filled with a value generated with the name of the App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings). | `any` | `{}` | no |
| auth\_settings\_v2 | Authentication settings V2. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2). | `any` | `{}` | no |
| backup\_custom\_name | Custom name for backup. | `string` | `null` | no |
| backup\_enabled | `true` to enable App Service backup. | `bool` | `false` | no |
| backup\_frequency\_interval | Frequency interval for the App Service backup. | `number` | `1` | no |
| backup\_frequency\_unit | Frequency unit for the App Service backup. Possible values are `Day` or `Hour`. | `string` | `"Day"` | no |
| backup\_keep\_at\_least\_one\_backup | Should the service keep at least one backup, regardless of age of backup. | `bool` | `true` | no |
| backup\_retention\_period\_in\_days | Retention in days for the App Service backup. | `number` | `30` | no |
| backup\_storage\_account\_container | Name of the container in the Storage Account if App Service backup is enabled. | `string` | `"webapps"` | no |
| backup\_storage\_account\_id | Storage account ID to use if App Service backup is enabled. | `string` | `null` | no |
| backup\_token\_start\_date | Start date for the backup SAS token. | `string` | `null` | no |
| certificates | Certificates for custom domains | <pre>map(object({<br/>    certificate_keyvault_certificate_id = optional(string)<br/>    certificate_keyvault_id             = optional(string)<br/>    certificate_file                    = optional(string)<br/>    certificate_password                = optional(string)<br/>  }))</pre> | `{}` | no |
| client\_affinity\_enabled | Client affinity activation for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled). | `bool` | `false` | no |
| client\_certificate\_enabled | Client certificate activation for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_certificate_enabled). | `bool` | `false` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| connection\_strings | Connection strings for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string). | `list(map(string))` | `[]` | no |
| custom\_domains | Custom domains and SSL certificates of the App Service. Could declare a custom domain with SSL binding. SSL certificate could be provided from an Azure Keyvault Certificate Secret or from a file with following attributes :<pre>- certificate_name:                     Name of the stored certificate.<br/>- certificate_keyvault_certificate_id:  ID of the Azure Keyvault Certificate Secret.</pre> | <pre>map(object({<br/>    certificate_name                    = optional(string)<br/>    certificate_keyvault_certificate_id = optional(string)<br/>    certificate_thumbprint              = optional(string)<br/>  }))</pre> | `{}` | no |
| custom\_name | Name of the App Service, generated if not set. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| https\_only | HTTPS restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only). | `bool` | `true` | no |
| identity | Map with identity block information. | <pre>object({<br/>    type         = string<br/>    identity_ids = list(string)<br/>  })</pre> | <pre>{<br/>  "identity_ids": [],<br/>  "type": "SystemAssigned"<br/>}</pre> | no |
| ip\_restriction\_headers | IPs restriction headers for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers). | `map(list(string))` | `null` | no |
| key\_vault\_reference\_identity\_id | The User Assigned Identity ID to use for the Key Vault secrets reference. If not set, the system assigned identity of the App Service will be used. | `string` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs | Configuration of the App Service and App Service slot logs. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app#logs). | <pre>object({<br/>    detailed_error_messages = optional(bool)<br/>    failed_request_tracing  = optional(bool)<br/>    application_logs = optional(object({<br/>      file_system_level = string<br/>      azure_blob_storage = optional(object({<br/>        level             = string<br/>        retention_in_days = number<br/>        sas_url           = string<br/>      }))<br/>    }))<br/>    http_logs = optional(object({<br/>      azure_blob_storage = optional(object({<br/>        retention_in_days = number<br/>        sas_url           = string<br/>      }))<br/>      file_system = optional(object({<br/>        retention_in_days = number<br/>        retention_in_mb   = number<br/>      }))<br/>    }))<br/>  })</pre> | `null` | no |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| mount\_points | Storage Account mount points. Name is generated if not set and default type is `AzureFiles`. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account). | <pre>list(object({<br/>    name         = optional(string)<br/>    type         = optional(string, "AzureFiles")<br/>    account_name = string<br/>    share_name   = string<br/>    access_key   = string<br/>    mount_path   = optional(string)<br/>  }))</pre> | `[]` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| public\_network\_access\_enabled | Whether enable public access for the App Service. | `bool` | `false` | no |
| resource\_group\_name | Resource group name. | `string` | n/a | yes |
| scm\_allowed\_cidrs | SCM IPs restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction). | `list(string)` | `[]` | no |
| scm\_allowed\_service\_tags | SCM Service Tags restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction). | `list(string)` | `[]` | no |
| scm\_allowed\_subnet\_ids | SCM subnets restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction). | `list(string)` | `[]` | no |
| scm\_ip\_restriction\_headers | IPs restriction headers for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers). | `map(list(string))` | `null` | no |
| service\_plan\_id | ID of the Service Plan that hosts the App Service. | `string` | n/a | yes |
| site\_config | Site config for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config). IP restriction attribute is no more managed in this block. | `any` | `{}` | no |
| stack | Project stack name. | `string` | n/a | yes |
| staging\_slot\_custom\_app\_settings | Override staging slot with custom app settings. | `map(string)` | `null` | no |
| staging\_slot\_custom\_name | Custom name of the app service slot. | `string` | `null` | no |
| staging\_slot\_enabled | Create a staging slot alongside the App Service for blue/green deployment purposes. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_slot). | `bool` | `true` | no |
| staging\_slot\_mount\_points | Storage Account mount points for staging slot. Name is generated if not set and default type is `AzureFiles`. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account). | <pre>list(object({<br/>    name         = optional(string)<br/>    type         = optional(string, "AzureFiles")<br/>    account_name = string<br/>    share_name   = string<br/>    access_key   = string<br/>    mount_path   = optional(string)<br/>  }))</pre> | `[]` | no |
| staging\_slot\_site\_config | Staging slot site config for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config). | `any` | `{}` | no |
| sticky\_settings | Lists of connection strings and app settings to prevent from swapping between slots. | <pre>object({<br/>    app_setting_names       = optional(list(string))<br/>    connection_string_names = optional(list(string))<br/>  })</pre> | `null` | no |
| vnet\_integration\_subnet\_id | ID of the subnet to associate with the App Service. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_insights\_app\_id | App id of the Application Insights associated to the App Service. |
| application\_insights\_application\_type | Application Type of the Application Insights associated to the App Service. |
| application\_insights\_id | ID of the Application Insights associated to the App Service. |
| application\_insights\_instrumentation\_key | Instrumentation key of the Application Insights associated to the App Service. |
| application\_insights\_name | Name of the Application Insights associated to the App Service. |
| certificates\_id | ID of certificates generated. |
| default\_site\_hostname | The Default Hostname associated with the App Service. |
| id | ID of the App Service. |
| identity\_principal\_id | ID of the system principal identity of the App Service. |
| module\_backup\_sas\_token | Backup SAS token module output. |
| module\_diagnostics | Diagnostics Settings module output. |
| module\_slot | App Service slot output. |
| name | Name of the App Service. |
| outbound\_ip\_addresses | Outbound IP adresses of the App Service. |
| possible\_outbound\_ip\_addresses | Possible outbound IP adresses of the App Service. |
| resource | Resource output. |
| resource\_application\_insights | Application insights output. |
| service\_plan\_id | ID of the Service Plan. |
| site\_credential | Site credential block of the App Service. |
| slot | Azure App Service slot output object. |
| slot\_identity\_principal\_id | ID of the system principal identity of the App Service Slot. |
| slot\_name | Name of the App Service slot. |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/app-service/overview](https://docs.microsoft.com/en-us/azure/app-service/overview)
