# Unreleased

Added
  * AZ-811: Add logs block parameters + add storage_account block to App Service Slot resources 

Fixed
  * AZ-811: Bump minimum AzureRM version (`v3.16.0`) to fix virtual_network_subnet_id property

# v6.0.1 - 2022-06-24

Fixed
  * AZ-772: Fix deprecated terraform code with `v1.2.3`

# v6.0.0 - 2022-06-10

Added
  * AZ-723: Composition of modules with two sub-module to handle AzureRM provider `v3.x` new resources (Linux, Windows and Container mode are now separated)
  * AZ-723: `service-plan` module is now included by default (Same behavior as `function-app` module)
  * AZ-717: Bump minimum Terraform (`v1.1+`) and AzureRM provider version
