# Outputs

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
