# v7.3.2 - 2023-06-07

Fixed
  * [GH-2](https://github.com/claranet/terraform-azurerm-app-service/pull/2): Fix `auth_settings` dynamic block

# v7.3.1 - 2023-04-14

Fixed
  * AZ-1047: Fix output `app_service_certificates_id` to include support for empty `custom_domains`
  * [GH-1](https://github.com/claranet/terraform-azurerm-app-service/pull/1): Fix `ip_restriction` and `scm_ip_restriction` parameters

Added
  * AZ-1047: Add `scm_minimum_tls_version` parameter

# v7.3.0 - 2023-03-10

Breaking
  * AZ-961: Add the optional `certificate_id` parameter in the `custom_domains` block

Changed
  * AZ-961: Name of `azurerm_app_service_certificate` resource will be the name of certificate file or Keyvault certificate

Fixed
  * AZ-961: Fix sensitive value error for the `custom_domains` block

# v7.2.1 - 2022-12-16

Changed
  * AZ-908: Bump App Service Plan module to `v6.1.1`

# v7.2.0 - 2022-11-28

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v7.1.0 - 2022-10-21

Added
  * AZ-882: Add `sticky_settings` block parameter
  * AZ-882: Add the optional parameter `slot_tag` in the `docker_image` block

# v7.0.1 - 2022-10-14

Fixed
  * AZ-877: Fix missing site_config attributes on slot

# v7.0.0 - 2022-09-30

Breaking
  * AZ-840: Update to Terraform `v1.3`

# v6.2.0 - 2022-09-09

Added
  * AZ-834: Add use_32_bit_worker parameter for site_config

# v6.1.0 - 2022-08-05

Added
  * AZ-811: Add logs block parameters + add `storage_account` block to App Service Slot resources
  * AZ-811: Add parameters in `site_config` block
  * AZ-811: Add App Service Container output

Fixed
  * AZ-811: Bump minimum AzureRM version (`v3.16.0`) to fix `virtual_network_subnet_id` property

Removed
  * AZ-811: Remove the legacy `WEBSITE_VNET_ROUTE_ALL` app setting to avoid permanent drift (only the `vnet_route_all_enabled` site config is needed)

# v6.0.1 - 2022-06-24

Fixed
  * AZ-772: Fix deprecated terraform code with `v1.2.3`

# v6.0.0 - 2022-06-10

Added
  * AZ-723: Composition of modules with two sub-module to handle AzureRM provider `v3.x` new resources (Linux, Windows and Container mode are now separated)
  * AZ-723: `service-plan` module is now included by default (Same behavior as `function-app` module)
  * AZ-717: Bump minimum Terraform (`v1.1+`) and AzureRM provider version
