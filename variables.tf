# Server

variable "administrator_login" {
  description = "(Required) The Administrator Login for the MySQL Flexible Server."
}

variable "administrator_password" {
  description = "(Required) The Password associated with the administrator_login for the MySQL Flexible Server."
}

variable "databases" {
  type        = map(map(string))
  description = "(Required) The name, collation, and charset of the MySQL database(s). (defaults: charset='utf8', collation='en_US.utf8')"
}

variable "diagnostics" {
  description = "Diagnostic settings for those resources that support it."
  type = object({
    destination   = string
    eventhub_name = string
    logs          = list(string)
    metrics       = list(string)
  })
  default = null
}

variable "ip_rules" {
  type        = list(string)
  description = "(Required) List of public IP or IP ranges in CIDR Format."
}

variable "firewall_rules" {
  type        = list(string)
  description = "(Required) Specifies the Start IP Address associated with this Firewall Rule."
}

variable "geo_redundant_backup_enabled" {
  description = "(Optional) Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server."
  type        = bool
  default     = true
}

variable "location" {
  description = "(Optional) Specifies the supported Azure location where the resource exists."
  default     = "canadacentral"
}

variable "name" {
  description = "(Required) The name of the MySQL Flexible Server."
}

variable "mysql_version" {
  description = "(Required) The version of the MySQL Flexible Server."
  default     = "8.0.21"
}

variable "resource_group" {
  description = "(Required) The name of the resource group in which to create the MySQL Flexible Server."
}

variable "sku_name" {
  description = "(Required) Specifies the SKU Name for this MySQL Flexible Server."
  default     = "GP_Standard_D4s_v3"
}

variable "storagesize_gb" {
  description = "(Required) Specifies the version of MySQL to use."
  default     = 20
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default = {
    environment : "dev"
  }
}

######################################################################
# kv_pointer_enable (pointers in key vault for secrets state)
# => ``true` then state from key vault is used for creation
# => ``false` then state from terraform is used for creation (default)
######################################################################

variable "kv_pointer_enable" {
  description = "(Optional) Flag kv_pointer_enable can either be `true` (state from key vault), or `false` (state from terraform)."
  default     = false
}

variable "kv_pointer_name" {
  description = "(Optional) The key vault name to be used when kv_pointer_enable is set to `true`."
  default     = null
}

variable "kv_pointer_rg" {
  description = "(Optional) The key vault resource group to be used when kv_pointer_enable is set to `true`."
  default     = null
}

variable "kv_pointer_sqladmin_password" {
  description = "(Optional) The sqladmin password to be looked up in key vault when kv_pointer_enable is set to `true`."
  default     = null
}

#########################################################
# Virtual Network Injection 
#########################################################

variable "subnet_id" {
  description = "The subnet where you want the database created. The subnet must be delegated to Microsoft.DBforMySQL/flexibleServers."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to create the MySQL Flexible Server. The private DNS zone must end with the suffix .mysql.database.azure.com."
  type        = string
  default     = null
}

#########################################################
# Parameters
#########################################################

variable "innodb_buffer_pool_size" {
  description = "(Optional) The size in bytes of the buffer pool, the memory area where InnoDB caches table and index data."
  default     = 16106127360
}

variable "max_allowed_packet" {
  description = "(Optional) The maximum size of one packet or any generated/intermediate string."
  default     = 536870912
}

variable "query_store_capture_interval" {
  description = "(Optional) The query store capture interval in minutes. Allows to specify the interval in which the query metrics are aggregated."
  default     = 15
}

variable "query_store_capture_mode" {
  description = "(Optional) The query store capture mode, NONE means do not capture any statements."
  default     = "ALL"
}

variable "query_store_capture_utility_queries" {
  description = "(Optional) Turning ON or OFF to capture all the utility queries that is executing in the system."
  default     = "YES"
}

variable "query_store_retention_period_in_days" {
  description = "(Optional) The query store capture interval in minutes. Allows to specify the interval in which the query metrics are aggregated."
  default     = 7
}

variable "table_definition_cache" {
  description = "(Optional) The number of table definitions (from .frm files) that can be stored in the definition cache."
  default     = 5000
}

variable "table_open_cache" {
  description = "(Optional) The number of open tables for all threads."
  default     = 5000
}

variable "redirect_enabled" {
  description = "(Optional) Indicate server support redirection."
  default     = "OFF"
}
