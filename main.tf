resource "azurerm_mysql_flexible_server" "mysql" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group

  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  administrator_login    = var.administrator_login
  administrator_password = (var.kv_pointer_enable && length(data.azurerm_key_vault_secret.pointer_sqladmin_password) > 0) ? data.azurerm_key_vault_secret.pointer_sqladmin_password[0].value : var.administrator_password

  sku_name   = var.sku_name
  version    = var.mysql_version

  storage {
    auto_grow_enabled = true
    size_gb           = var.storagesize_gb
  }

  backup_retention_days        = 35
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags,
      zone
    ]
  }
}

resource "azurerm_mysql_flexible_database" "mysql" {
  for_each    = var.databases
  server_name         = azurerm_mysql_flexible_server.mysql.name
  resource_group_name = var.resource_group
  
  name        = each.key
  charset     = lookup(each.value, "charset", "utf8")
  collation   = lookup(each.value, "collation", "utf8_unicode_ci")
}

#########################################################################################
# Configure Networking
#########################################################################################

resource "azurerm_mysql_flexible_server_firewall_rule" "mysql" {
  for_each        = toset(var.firewall_rules)
  server_name         = azurerm_mysql_flexible_server.mysql.name
  resource_group_name = var.resource_group

  name             = replace(each.key, ".", "-")
  start_ip_address = each.key
  end_ip_address   = each.key
}
