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
  description = "Is Geo-Redundant backup enabled on the MySQL Flexible Server."
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

variable "storage_account_name" {
  description = "Name of the storage account used for diagnostics (optional, if not provided the name is auto-generated)."
  default     = null
}

variable "mysql_version" {
  description = "The version of the MySQL Flexible Server."
  default     = "8.0.21"
}

variable "resource_group_name" {
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

variable "project" {
  description = "Name of client project"
}

variable "environment" {
  description = "The environment used for keyvault access."
}

##################
### Networking ###
##################

variable "delegated_subnet_id" {
  description = "The subnet where you want the database created. The subnet must be delegated to Microsoft.DBforMySQL/flexibleServers."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to create the MySQL Flexible Server. The private DNS zone must end with the suffix .mysql.database.azure.com."
  type        = string
  default     = null
}

variable "kv_private_endpoints" {
  description = "The information required to create a private endpoint for the Key Vault."
  type = list(object({
    sub_resource_name   = optional(string, "vault")
    subnet_id           = string
    private_dns_zone_id = string
  }))
  default = []

  validation {
    condition = alltrue([
      for entry in var.kv_private_endpoints :
      contains(["vault"], entry.sub_resource_name)
    ])
    error_message = "Invalid sub_resource_name within var.kv_private_endpoints. Expected the name to be 'vault'."
  }

  validation {
    condition = alltrue([
      for entry in var.kv_private_endpoints :
      element(split("/", entry.private_dns_zone_id), 8) == "privatelink.vaultcore.azure.net"
    ])
    error_message = "Invalid private_dns_zone_id attribute within var.kv_private_endpoints. Expected a Private DNS Zone with the name 'privatelink.vaultcore.azure.net'"
  }
}

variable "public_network_access_enabled" {
  description = "(Required) Whether or not public network access is allowed."
  default     = false
}

variable "kv_subnet_ids" {
  description = "The subnets for the key vault."
  type        = list(string)
  default     = null
}

variable "sa_subnet_ids" {
  description = "The subnets for the storage account."
  type        = list(string)
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

variable "sa_create_log" {
  description = "Creates a storage account to be used for diagnostics logging of the MySQL database created if the variable is set to `true`."
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

variable "mysql_configurations" {
  type = map(string)
  default = {
    audit_log_enabled       = "ON"
    audit_log_events        = "CONNECTION_V2, ADMIN"
    max_connect_errors      = "20"
    innodb_buffer_pool_size = "12884901888"
    max_allowed_packet      = "536870912"
    table_definition_cache  = "5000"
    table_open_cache        = "5000"
  }
}

variable "active_directory_administrator" {
  type = list(object({
    object_id = optional(string)
    login     = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for entry in var.active_directory_administrator :
      (entry.object_id != null) &&
      (entry.login != null)
    ])
    error_message = "Invalid active_directory_administrator configuration. Make sure object_id and login are not null"
  }
}