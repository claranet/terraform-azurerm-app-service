# Network/firewall variables

variable "public_network_access_enabled" {
  description = "Whether the Azure App Service slot is available from public network."
  type        = bool
  default     = false
}

variable "app_service_vnet_integration_subnet_id" {
  description = "Id of the subnet to associate with the App Service slot."
  type        = string
  default     = null
}

variable "ip_restriction" {
  description = "IP restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction."
  type        = any
  default     = {}
}

variable "scm_ip_restriction" {
  description = "SCM IP restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction."
  type        = any
  default     = {}
}

variable "scm_authorized_ips" {
  description = "SCM IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_authorized_subnet_ids" {
  description = "SCM subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
  type        = list(string)
  default     = []
}
