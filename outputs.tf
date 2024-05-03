###############
### Server ###
###############

output "id" {
  value = azurerm_mysql_flexible_server.mysql.id
}

output "fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "administrator_login" {
  value = azurerm_mysql_flexible_server.mysql.administrator_login
}

output "log_category_types" {
  value = data.azurerm_monitor_diagnostic_categories.mysql_server[0].log_category_types
}

output "log_category_groups" {
  value = data.azurerm_monitor_diagnostic_categories.mysql_server[0].log_category_groups
}

output "metric" {
  value = data.azurerm_monitor_diagnostic_categories.mysql_server[0].metrics
}