provider "azurerm" {
  features {}
}

module "mysql_example" {
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-azurerm-flex-mysql.git?ref=v4.0.0"

  name = "mysqlservername"
  databases = {
    mysqlservername1 = { collation = "utf8_unicode_ci" },
    mysqlservername2 = { chartset = "utf8" },
    mysqlservername3 = { chartset = "utf8", collation = "utf8_unicode_ci" },
    mysqlservername4 = {}
  }

  administrator_login    = "mysqladmin"
  administrator_password = "mySql1313!"

  sku_name       = "GP_Standard_D2ds_v4"
  storagesize_gb = 20

  location       = "canadacentral"
  resource_group = "Test"

  ip_rules       = []
  firewall_rules = []

  # Needs to be disabled until the following issue is resolved: https://github.com/MicrosoftDocs/azure-docs/issues/32068
  # diagnostics = {
  #   destination   = ""
  #   eventhub_name = ""
  #   logs          = ["all"]
  #   metrics       = ["all"]
  # }

  tags = {
    "tier" = "k8s"
  }

  # The variables required for vnet integration.  
  #subnet_id           = ""
  #private_dns_zone_id = ""

  ######################################################################
  # kv_pointer_enable (pointers in key vault for secrets state)
  # => ``true` then state from key vault is used for creation
  # => ``false` then state from terraform is used for creation (default)
  ######################################################################
  # kv_pointer_enable            = false
  # kv_pointer_name              = "kvpointername"
  # kv_pointer_rg                = "kvpointerrg"
  # kv_pointer_sqladmin_password = "sqlhstsvc"

}
