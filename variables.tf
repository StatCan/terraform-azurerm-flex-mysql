###############
### Server ###
###############

variable "administrator_login" {
  description = "The Administrator Login for the MySQL Flexible Server."
}

variable "administrator_password" {
  description = "The Password associated with the administrator_login for the MySQL Flexible Server."
  sensitive   = true
}

variable "databases" {
  type        = map(map(string))
  description = "The name, collation, and charset of the MySQL database(s). (defaults: charset='utf8', collation='utf8_unicode_ci')"
}

variable "ip_rules" {
  type        = list(string)
  description = "List of public IP or IP ranges in CIDR Format."
}

variable "firewall_rules" {
  type        = list(string)
  description = "Specifies the Start IP Address associated with this Firewall Rule."
}

variable "geo_redundant_backup_enabled" {
  description = "Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server."
  type        = bool
  default     = false
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists."
  default     = "canadacentral"
}

variable "name" {
  description = "The name of the MySQL Flexible Server."
}

variable "mysql_version" {
  description = "The version of the MySQL Flexible Server."
  default     = "8.0.21"
}

variable "resource_group" {
  description = "The name of the resource group in which to create the MySQL Flexible Server."
}

variable "sku_name" {
  description = "Specifies the SKU Name for this MySQL Flexible Server."
  default     = "GP_Standard_D4ds_v4"
}

variable "storagesize_gb" {
  description = "Specifies the version of MySQL to use."
  default     = 128
}

variable "iops" {
  description = "The storage IOPS for the MySQL Flexible Server."
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default = {
    environment : "dev"
  }
}

##################
### Networking ###
##################

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

###############
### Logging ###
###############

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

variable "create_log_sa" {
  description = "Creates a storage account to be used for diagnostics logging of the PostgreSQL database created if the variable is set to `true`."
  type        = bool
  default     = false
}

##################
### KV Pointer ###
##################

######################################################################
# kv_pointer_enable (pointers in key vault for secrets state)
# => ``true` then state from key vault is used for creation
# => ``false` then state from terraform is used for creation (default)
######################################################################

variable "kv_pointer_enable" {
  description = "Flag kv_pointer_enable can either be `true` (state from key vault), or `false` (state from terraform)."
  default     = false
}

variable "kv_pointer_name" {
  description = "The key vault name to be used when kv_pointer_enable is set to `true`."
  default     = null
}

variable "kv_pointer_rg" {
  description = "The key vault resource group to be used when kv_pointer_enable is set to `true`."
  default     = null
}

variable "kv_pointer_sqladmin_password" {
  description = "The sqladmin password to be looked up in key vault when kv_pointer_enable is set to `true`."
  default     = null
}

##################
### Parameters ###
##################

variable "innodb_buffer_pool_size" {
  description = "The size in bytes of the buffer pool, the memory area where InnoDB caches table and index data."
  default     = 12884901888
}

variable "max_allowed_packet" {
  description = "The maximum size of one packet or any generated/intermediate string."
  default     = 536870912
}

variable "table_definition_cache" {
  description = "The size of the table_definition_cache."
  default     = 5000
}

variable "table_open_cache" {
  description = "The size of the table_open_cache."
  default     = 5000
}
