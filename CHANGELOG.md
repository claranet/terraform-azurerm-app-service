## 8.0.0 (2025-01-24)

### ⚠ BREAKING CHANGES

* **AZ-1088:** AzureRM Provider v4+ and OpenTofu 1.8+

### Features

* **AZ-1088:** add health_check_eviction_time_in_min in site_config b8a71c8
* **AZ-1088:** module v8 structure and updates 3a497a6
* **AZ-1088:** upgrade `linux-web-app` submodule to v8 d1851a3
* **AZ-1088:** windows webapp submodule update v8 5858ad5

### Bug Fixes

* **AZ-1088:** add missing moved block ebd8359
* don't set `java_embedded_server_enabled` by default 8276541
* move win slot acdefa3

### Documentation

* **AZ-1088:** bump container-webapp example e516e08
* **AZ-1088:** update linux example 282d8a3
* fix windows sebapp example c3590c1

### Code Refactoring

* align `var.staging_slot_site_config` variable 187f5e1
* **AZ-1088:** module update 12709aa
* **AZ-1088:** update variables 7d24e7b

### Miscellaneous Chores

* **deps:** update dependency claranet/app-service-plan/azurerm to v8 88c9417
* **deps:** update dependency opentofu to v1.8.6 79eaa22
* **deps:** update dependency opentofu to v1.8.8 cfa873c
* **deps:** update dependency opentofu to v1.9.0 2279b12
* **deps:** update dependency pre-commit to v4.1.0 97fa963
* **deps:** update dependency tflint to v0.54.0 fda7d7e
* **deps:** update dependency tflint to v0.55.0 4050bb2
* **deps:** update dependency trivy to v0.57.1 7835746
* **deps:** update dependency trivy to v0.58.1 5e5284c
* **deps:** update dependency trivy to v0.58.2 e9bf5eb
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 78ab475
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 b173b88
* **deps:** update tools a475700
* update tflint config for v0.55.0 e454b38

## 7.14.1 (2024-11-08)

### Documentation

* **examples:** update ACR usage example 4b56bc3

### Miscellaneous Chores

* **deps:** update tools e4fc8d8

## 7.14.0 (2024-10-25)

### Features

* **AZ-1464:** add slot module 1dcbe14
* **AZ-1464:** add slot submodule to container-web-app submodule 36f3d95
* **AZ-1464:** add slot submodule to windows-web-app submodule 6ba762a
* **AZ-1467:** add `ip_restriction_default_action` 5a23c8d
* **AZ-1467:** require minimum AzureRM provider version `3.95+` e7bc492, closes /github.com/hashicorp/terraform-provider-azurerm/blob/main/CHANGELOG-v3.md#3950-march-08-2024

### Documentation

* **AZ-1464:** add example and update README 3c02edf

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.3 5c4b8ca
* **deps:** update dependency opentofu to v1.8.4 8fcae54
* **deps:** update dependency pre-commit to v4 630f9c8
* **deps:** update dependency pre-commit to v4.0.1 b4774a8
* **deps:** update dependency trivy to v0.56.2 a1854a2
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 682db9b
* update examples structure a8a0c7a

## 7.13.1 (2024-10-08)

### Documentation

* update submodule READMEs with latest template 012789a

### Miscellaneous Chores

* **deps:** update dependency trivy to v0.56.1 752898e
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 8856288
* **deps:** update terraform claranet/storage-sas-token/azurerm to v7.0.1 f2706b3
* prepare for new examples structure 1c54d99

## 7.13.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider ac54965

### Documentation

* update README badge to use OpenTofu registry f447af3
* update README with `terraform-docs` v0.19.0 04bf6d6
* update sub-modules README with `terraform-docs` v0.19.0 8dec958

### Miscellaneous Chores

* **deps:** update dependency terraform-docs to v0.19.0 69e50e3
* **deps:** update dependency trivy to v0.55.2 48f0070
* **deps:** update dependency trivy to v0.56.0 16c7ca7
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 5ea0202
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 0216bb6
* **deps:** update terraform claranet/app-service-plan/azurerm to ~> 7.1.0 67a7379
* **deps:** update terraform claranet/diagnostic-settings/azurerm to v7 615055c

## 7.12.1 (2024-09-13)

### Documentation

* update container app service example with ACR usage ab6c86d

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.3 859c051
* **deps:** update dependency opentofu to v1.8.0 7015f5d
* **deps:** update dependency opentofu to v1.8.1 b1dafd6
* **deps:** update dependency pre-commit to v3.8.0 e311f06
* **deps:** update dependency tflint to v0.51.2 63fe8d7
* **deps:** update dependency tflint to v0.52.0 7b67b5a
* **deps:** update dependency tflint to v0.53.0 d82ab97
* **deps:** update dependency trivy to v0.52.2 ea1cc9b
* **deps:** update dependency trivy to v0.53.0 6148047
* **deps:** update dependency trivy to v0.54.1 522ae1f
* **deps:** update dependency trivy to v0.55.0 dbd8d2d
* **deps:** update dependency trivy to v0.55.1 5f3fdcf
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 090a501
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 f153409
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 0085967
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 4cbf0be
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 ffedbbe
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.3 98e58b5
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 39cccff
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 0f3c486
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 c9db14f
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 180e4a4
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 6e5c0af
* **deps:** update terraform claranet/storage-sas-token/azurerm to v7 02497ea
* **deps:** update tools c4f6cf8

## 7.12.0 (2024-06-14)


### Features

* upgrade `service-plan` module to `v7.0` 5656d20


### Continuous Integration

* **AZ-1391:** update semantic-release config [skip ci] 66a5c46


### Miscellaneous Chores

* **deps:** enable automerge on renovate 501e3dd
* **deps:** update dependency opentofu to v1.7.0 9867572
* **deps:** update dependency opentofu to v1.7.1 a5426db
* **deps:** update dependency opentofu to v1.7.2 de038f7
* **deps:** update dependency pre-commit to v3.7.1 7c56ae8
* **deps:** update dependency terraform-docs to v0.18.0 584524e
* **deps:** update dependency tflint to v0.51.0 8778217
* **deps:** update dependency tflint to v0.51.1 877080a
* **deps:** update dependency trivy to v0.50.2 0213414
* **deps:** update dependency trivy to v0.50.4 1465250
* **deps:** update dependency trivy to v0.51.0 9e19566
* **deps:** update dependency trivy to v0.51.1 d339832
* **deps:** update dependency trivy to v0.51.2 06fb91b
* **deps:** update dependency trivy to v0.51.3 392098f
* **deps:** update dependency trivy to v0.51.4 ed70baf
* **deps:** update dependency trivy to v0.52.0 dd5081c
* **deps:** update dependency trivy to v0.52.1 a6164aa
* **deps:** update terraform claranet/app-service-plan/azurerm to ~> 6.5.0 a0be2bf
* **pre-commit:** update commitlint hook ae5f684
* **release:** remove legacy `VERSION` file fb9ee68

## 7.11.0 (2024-04-19)


### Features

* **AZ-1362:** add log analytics precondition and parameters 5b5ad4f


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 1a7c33c


### Miscellaneous Chores

* **deps:** add renovate.json b5a394c
* **deps:** update renovate.json 8358e55
* **deps:** update terraform claranet/storage-sas-token/azurerm to v4 ac5ab2f

# v7.10.0 - 2024-03-01

Changed
  * AZ-1360: improve `mount_points` variable, support `staging_slot_mount_points` for slot

# v7.9.2 - 2024-01-26

Changed
  * [GH-15](https://github.com/claranet/terraform-azurerm-app-service/pull/15): Bump service-plan module to `v6.4.0`

# v7.9.1 - 2023-12-22

Fixed
  * AZ-1246: Fix failed git rebase

# v7.9.0 - 2023-12-08

Fixed
  * AZ-1246: Fix `auth_settings_v2` block/options

Added
  * AZ-1203: Handle wildcard certificates
  * AZ-1249: Add slot settings

Changed
  * AZ-1246: Cleanup deprecated attributes

# v7.8.1 - 2023-10-20

Fixed
  * [GH-11](https://github.com/claranet/terraform-azurerm-app-service/pull/11): Fix variable `auth_settings_v2` null value error

# v7.8.0 - 2023-10-10

Changed
  * AZ-1176: Use App Service `virtual_network_subnet_id` attribute for VNet integration instead of legacy swift resource

Fixed
  * AZ-1176: Fix public exposition for app service slots

# v7.7.0 - 2023-09-25

Added
   * [GH-5](https://github.com/claranet/terraform-azurerm-app-service/issues/5): Add Support for Auth Settings V2

# v7.6.1 - 2023-09-08

Fixed
  * [GH-7](https://github.com/claranet/terraform-azurerm-app-service/pull/7): Propagate `public_network_access_enabled` variable also to windows and container modules

# v7.6.0 - 2023-09-08

Breaking
  * AZ-1153: Remove `retention_days` parameters, it must be handled at destination level now. (for reference: [Provider issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/23051))

# v7.5.0 - 2023-08-22

Added
    * [GH-4](https://github.com/claranet/terraform-azurerm-app-service/pull/4): Add support for User Assigned Identities

# v7.4.0 - 2023-08-11

Added
  * AZ-1125: Add support of `public_network_access_enabled` variable

Changed
  * AZ-1125: Bump AzureRM provider version to `~> 3.64`

# v7.3.3 - 2023-07-13

Fixed
  * AZ-1113: Update sub-modules READMEs (according to their example)

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
