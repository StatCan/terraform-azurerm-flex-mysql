##############################
### User Assigned Identity ###
##############################

# Manages a User Assigned Identity.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
#
resource "azurerm_user_assigned_identity" "mysql" {
  name                = "${var.name}-db-msi"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags
}

###############################
### Managed MySQL for Azure ###
###############################

# Manages a MySQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server
#
resource "azurerm_mysql_flexible_server" "mysql" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group

  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  administrator_login    = var.administrator_login
  administrator_password = (var.kv_pointer_enable && length(data.azurerm_key_vault_secret.pointer_sqladmin_password) > 0) ? data.azurerm_key_vault_secret.pointer_sqladmin_password[0].value : var.administrator_password

  sku_name = var.sku_name
  version  = var.mysql_version

  storage {
    auto_grow_enabled = true
    iops              = var.iops
    size_gb           = var.storagesize_gb
  }

  customer_managed_key {
    key_vault_key_id                  = azurerm_key_vault_key.cmk.id
    primary_user_assigned_identity_id = azurerm_user_assigned_identity.mysql.id
  }

  backup_retention_days        = 35
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  zone                         = 1

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags,
      zone
    ]
  }
}

# Manages a MySQL Database within a MySQL Flexible Server
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database
#
resource "azurerm_mysql_flexible_database" "mysql" {
  for_each            = var.databases
  server_name         = azurerm_mysql_flexible_server.mysql.name
  resource_group_name = var.resource_group

  name      = each.key
  charset   = lookup(each.value, "charset", "utf8")
  collation = lookup(each.value, "collation", "utf8_unicode_ci")
}

# Manages a Firewall Rule for a MySQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule
#
resource "azurerm_mysql_flexible_server_firewall_rule" "mysql" {
  for_each            = toset(var.firewall_rules)
  server_name         = azurerm_mysql_flexible_server.mysql.name
  resource_group_name = var.resource_group

  name             = replace(each.key, ".", "-")
  start_ip_address = each.key
  end_ip_address   = each.key
}

# Sets a MySQL Flexible Server Configuration value on a MySQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration
#
resource "azurerm_mysql_flexible_server_configuration" "max_allowed_packet" {
  name                = "max_allowed_packet"
  resource_group_name = var.resource_group
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = var.max_allowed_packet
}

# Sets a MySQL Flexible Server Configuration value on a MySQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration
#
resource "azurerm_mysql_flexible_server_configuration" "innodb_buffer_pool_size" {
  name                = "innodb_buffer_pool_size"
  resource_group_name = var.resource_group
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = var.innodb_buffer_pool_size
}

# Sets a MySQL Flexible Server Configuration value on a MySQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration
#
resource "azurerm_mysql_flexible_server_configuration" "table_definition_cache" {
  name                = "table_definition_cache"
  resource_group_name = var.resource_group
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = var.table_definition_cache
}

# Sets a MySQL Flexible Server Configuration value on a MySQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration
#
resource "azurerm_mysql_flexible_server_configuration" "table_open_cache" {
  name                = "table_open_cache"
  resource_group_name = var.resource_group
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = var.table_open_cache
}
