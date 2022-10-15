provider "azurerm" {
  features {}
}

module "mysql_example" {
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-azurerm-flex-mysql.git?ref=main"

  name = "mysqlservername"
  databases = {
    mysqlservername1 = { collation = "utf8_unicode_ci" },
    mysqlservername2 = { chartset = "utf8" },
    mysqlservername3 = { chartset = "utf8", collation = "utf8_unicode_ci" },
    mysqlservername4 = {}
  }

  administrator_login    = "mysqladmin"
  administrator_password = "mySql1313"

  sku_name       = "GP_Standard_D4ds_v4"
  mysql_version  = "8.0.21"
  storagesize_gb = 512
  iops           = 4000

  location       = "canadacentral"
  resource_group = "mysql-dev-rg"

  ip_rules       = []
  firewall_rules = []

  diagnostics = {
    destination   = ""
    eventhub_name = ""
    logs          = ["all"]
    metrics       = ["all"]
  }

  tags = {
    "tier" = "k8s"
  }

}

