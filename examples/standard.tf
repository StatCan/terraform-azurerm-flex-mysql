#####################
### Prerequisites ###
#####################

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias = "dns_zone_provider"
}

############
### Data ###
############

# data "azurerm_private_dns_zone" "flex_dns_zone" {
#   name                = "privatelink.mysql.database.azure.com"
#   resource_group_name = "mysql-dev-rg"
#   provider            = azurerm.dns_zone_provider
# }

# data "azurerm_subnet" "back" {
#   name                 = "back-dev"
#   resource_group_name  = "mysql-dev-rg"
#   virtual_network_name = "mysql-dev-vnet"
# }

# data "azurerm_subnet" "database" {
#   name                 = "mysql-dev"
#   resource_group_name  = "mysql-dev-rg"
#   virtual_network_name = "mysql-dev-vnet"
# }

##############
### Locals ###
##############

locals {
  subnet_ids = []
}

###############################
### Managed MySQL for Azure ###
###############################

# Manages a MySQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server
#
module "mysql_example" {
  source = "../"

  name           = "mysqlservername"
  location       = "canadacentral"
  resource_group = "mysql-dev-rg"

  databases = {
    mysqlservername1 = { collation = "utf8_unicode_ci" },
    mysqlservername2 = { chartset = "utf8" },
    mysqlservername3 = { chartset = "utf8", collation = "utf8_unicode_ci" },
    mysqlservername4 = {}
  }

  administrator_login    = "mysqladmin"
  administrator_password = "mySql1313"

  geo_redundant_backup_enabled = false

  sku_name      = "GP_Standard_D4ds_v4"
  mysql_version = "8.0.21"

  storagesize_gb = 512
  iops           = 4000

  ip_rules       = []
  firewall_rules = []

  diagnostics = {
    destination   = ""
    eventhub_name = ""
    logs          = ["all"]
    metrics       = ["all"]
  }

  # delegated_subnet_id = data.azurerm_subnet.database.id
  # private_dns_zone_id = data.azurerm_private_dns_zone.flex_dns_zone.id

  public_network_access_enabled = false

  # kv_subnet_ids                 = concat([data.azurerm_subnet.database.id], local.subnet_ids)
  # kv_private_endpoints = [
  #   {
  #     subnet_id = data.azurerm_subnet.back.id
  #   }
  # ]

  sa_create_log = true
  # sa_subnet_ids = concat([data.azurerm_subnet.database.id], local.subnet_ids)

  tags = {
    "tier" = "k8s"
  }

  providers = {
    azurerm                   = azurerm
    azurerm.dns_zone_provider = azurerm.dns_zone_provider
  }
}
