# v5.1.0 - 2022-02-03

Added
  * AZ-615: Add an option to enable or disable default tags

# v5.0.0 - 2022-01-13

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+

# v4.6.0 - 2022-01-13

Added
  * AZ-638: Add `acr_use_managed_identity_credentials` in `site_config` option (AzureRM v2.71+)

# v4.5.1 - 2021-11-23

Fixed
  * AZ-603: Terraform 1.1 compatibility
  * AZ-589: Avoid plan drift when specifying Diagnostic Settings categories

# v4.5.0 - 2021-10-25

Added
  * AZ-584: Allow to configure Application Insight's percentage sampling data

# v4.4.0 - 2021-10-15

Added
  * AZ-554: Add slot option

Changed
  * AZ-572: Revamp examples and improve CI

# v4.3.1 - 2021-09-03

Fixed
  * AZ-548: Add IP restrictions headers variables
  * AZ-548: Diagnostics settings can now be named correctly
  * AZ-548: Fix SCM IP restriction service tags
  * AZ-548: Fix other linter issues
  * AZ-558: Fix README example

Updated
  * AZ-532: Revamp README with latest `terraform-docs` tool

# v4.3.0 - 2021-06-03

Changed
  * AZ-495: Module code upgrade, now compatible with Terraform `0.15+`

Breaking
  * AZ-160: Unify diagnostics settings on all Claranet modules

Added
  * AZ-500: Add backup retention period in days argument

# v4.2.0 - 2021-03-09

Added
  * AZ-424: Add Service Tags (AzureRM v2.42+)
  * AZ-374: Allow disabling Application Insights deployment
  * AZ-423: Use connection string for Application Insights integration (changed variable from key to id)

# v4.1.0 - 2021-01-15

Changed
  * AZ-398: Force lowercase on default generated name

Added
  * AZ-331: VNet integration

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
