########################
### Storage Accounts ###
########################

# Manages an Azure Storage Account.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
#
resource "azurerm_storage_account" "mysql" {
  count = var.sa_create_log ? 1 : 0

  name                            = var.storage_account_name != null ? var.storage_account_name : substr("${replace(var.name, "-", "")}mysql", 0, 24)
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = "Hot"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.sa_subnet_ids == null ? [] : var.sa_subnet_ids
    bypass                     = ["AzureServices"]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_role_assignment" "sa" {
  count = var.sa_create_log ? 1 : 0

  description          = "${var.name}-ra"
  scope                = azurerm_storage_account.mysql[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_mysql_flexible_server.mysql.id

  depends_on = [
    azurerm_storage_account.mysql
  ]
}

#########################
### Storage Container ###
#########################

# Manages a Container within an Azure Storage Account.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
#
resource "azurerm_storage_container" "mysql" {
  count = var.sa_create_log ? 1 : 0

  name                  = "${replace(var.name, "-", "")}mysql"
  storage_account_name  = azurerm_storage_account.mysql[0].name
  container_access_type = "private"

  depends_on = [
    azurerm_role_assignment.sa
  ]
}
