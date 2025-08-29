# CHANGE LOG

## 1.0.0 (Aug 26, 2025)

FEATURES:

* Provider definitions and key vault dependancy updated to use AzureRM version 4.
* Updates to storage account container references from name to id, to support provider changes.
* Updates to support changes to diagnostics resource.

ENHANCEMENTS:

* Added validations to variables iops, storagesize_gb.
* Added additional audit logging.
* Added support for public_network_access.

BUG FIXES:

## 0.6.0 (July 15, 2024)

FEATURES:

ENHANCEMENTS:

BUG FIXES:

* `enc_key_vault` - fix dependency issue with creation

## 0.5.0 (March 15, 2024)

FEATURES:

ENHANCEMENTS:

* `azurerm_mysql_flexible_server_active_directory_administrator` - Entra  enabled
* `enc_key_vault` - referring to latest keyvault module

BUG FIXES:

* `azurerm_monitor_diagnostic_setting` - deprecated inputs renamed
