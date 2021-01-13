# v4.1.0 - 2021-01-15

Changed
  * AZ-398: Force lowercase on default generated name

Added
  * AZ-331: VNet integration
  * AZ-424: Add Service Tags (AzureRM 2.42+)

# v3.2.1/v4.0.0 - 2020-11-19

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

# v3.2.0 - 2020-11-17

Added
  * AZ-265: Add SCM IP restriction feature

Updated
  * AZ-133: README update for logs storage declaration

Fixed
  * AZ-263: Update `ip_restriction` block with new attributes

# v3.1.0 - 2020-07-30

Added
  * AZ-241: Add `diag_settings_custom_name` parameter

# v3.0.0 - 2020-07-09

Added
  * AZ-221: Add `health_check_path site_config` parameter

Breaking
  * AZ-221: AzureRM provider 2.0 compatibility

# v2.2.0 - 2020-04-06

Added
  * AZ-176: Implement certificate and custom hostname binding features

Fixed
  * AZ-194: Fix `site_config` type

# v2.1.1 - 2020-02-11

Changed
  * AZ-177: Fix backup declaration

# v2.1.0 - 2020-01-31

Added
  * AZ-121: Implement backup feature
  * AZ-158: Manage authentication settings
  * AZ-118: Add LICENSE, NOTICE & Github badges
  * AZ-119: Add CONTRIBUTING.md doc and `terraform-wrapper` usage with the module

Changed
  * AZ-143: Support ip restriction
  * AZ-133: Use diagnostics settings for logs
  * AZ-119: Revamp README and publish this module to Terraform registry

# v2.0.0 - 2019-10-29

Breaking
  * AZ-94: Terraform 0.12 / HCL2 format

# v1.0.0 - 2019-05-15

Added
  * AZ-41: First release
