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

data "azurerm_private_dns_zone" "flex_dns_zone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = "mysql-dev-rg"
  provider            = azurerm.dns_zone_provider
}

data "azurerm_private_dns_zone" "kv" {
  provider            = azurerm.dns_zone_provider
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = "network-management-rg"
}

data "azurerm_subnet" "back" {
  name                 = "back-dev"
  resource_group_name  = "mysql-dev-rg"
  virtual_network_name = "mysql-dev-vnet"
}

data "azurerm_subnet" "mysql" {
  name                 = "mysql-dev"
  resource_group_name  = "mysql-dev-rg"
  virtual_network_name = "mysql-dev-vnet"
}

##############
### Locals ###
##############

locals {
  subnet_ids = []
}


#####################
# These variables can have their values set as CI/CD Variables with the names TF_VAR_MYSQL_Admin_Username and TF_VAR_MYSQL_Admin_Password.

variable "MYSQL_Admin_Username" {
  type        = string
  description = "The Administrator Login for the MYSQL Flexible Server."
}

variable "MYSQL_Admin_Password" {
  type        = string
  sensitive   = true
  description = "The Password associated with the administrator_login for the MYSQL Flexible Server."
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

  name                = "mysqlservername"
  location            = "canadacentral"
  resource_group_name = "mysql-dev-rg"

  databases = {
    mysqlservername1 = { collation = "utf8_unicode_ci" },
    mysqlservername2 = { chartset = "utf8" },
    mysqlservername3 = { chartset = "utf8", collation = "utf8_unicode_ci" },
    mysqlservername4 = {}
  }

  administrator_login    = var.MYSQL_Admin_Username # See above variable definitions
  administrator_password = var.MYSQL_Admin_Password

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
  }

  delegated_subnet_id = data.azurerm_subnet.mysql.id
  private_dns_zone_id = data.azurerm_private_dns_zone.flex_dns_zone.id

  kv_subnet_ids = local.subnet_ids
  kv_private_endpoints = [
    {
      subnet_id           = data.azurerm_subnet.back.id,
      private_dns_zone_id = data.azurerm_private_dns_zone.kv.id
    }
  ]

  sa_create_log = true
  sa_subnet_ids = local.subnet_ids

  environment = "dev"
  project     = "mysql"
  tags = {
    "tier" = "k8s"
  }

  providers = {
    azurerm                   = azurerm
    azurerm.dns_zone_provider = azurerm.dns_zone_provider
  }
}
