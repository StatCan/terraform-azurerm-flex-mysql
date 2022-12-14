# Storage Accounts

########################
### Storage Accounts ###
########################

# Manages an Azure Storage Account.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
#
resource "azurerm_storage_account" "mysql" {
  count = var.create_log_sa ? 1 : 0

  name                            = substr("${replace(var.name, "-", "")}mysql", 0, 24)
  location                        = var.location
  resource_group_name             = var.resource_group
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = "Hot"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

  network_rules {
    default_action             = var.subnet_id == null ? "Allow" : "Deny"
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.subnet_id == null ? [] : [var.subnet_id]
    bypass                     = ["AzureServices"]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

#########################
### Storage Container ###
#########################

# Manages a Container within an Azure Storage Account.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
#
resource "azurerm_storage_container" "mysql" {
  count = var.create_log_sa ? 1 : 0

  name                  = "${replace(var.name, "-", "")}mysql"
  storage_account_name  = azurerm_storage_account.mysql[count.index].name
  container_access_type = "private"
}
