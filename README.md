# Terraform for Azure Managed Database MySQL Flexible Server

Creates a MySQL instance using the Azure Managed Database for MySQL Flexible Server.

## Security Controls

- TBD

## Dependencies

- Terraform v0.14.x +
- Terraform AzureRM Provider 2.5 +

## Usage

Examples for this module along with various configurations can be found in the [examples/](examples/) folder.

## Variables

| Name                   | Type             | Default                | Required | Description                                                                                                        |
| ---------------------- | ---------------- | ---------------------- | -------- | ------------------------------------------------------------------------------------------------------------------ |
| administrator_login    | string           | n/a                    | yes      | The Administrator Login for the MySQL Flexible Server.                                                        |
| administrator_password | string           | n/a                    | yes      | The Password associated with the administrator_login for the MySQL Flexible Server.                           |
| databases              | map(map(string)) | n/a                    | yes      | The name, collation, and charset of the MySQL database(s). (defaults: charset='utf8', collation='en_US.utf8') |
| diagnostics            | object()         | null                   | no       | Diagnostic settings for those resources that support it.                                                           |
| ip_rules               | list             | n/a                    | yes      | List of public IP or IP ranges in CIDR Format.                                                                     |
| firewall_rules         | list             | n/a                    | yes      | Specifies the Start IP Address associated with this Firewall Rule.                                                 |
| location               | string           | `"canadacentral"`      | no       | Specifies the supported Azure location where the resource exists.                                                  |
| name                   | string           | n/a                    | yes      | The name of the MySQL Flexible Server.                                                                        |
| mysql_version          | string           | `"8.0.21"`                 | no       | The version of the MySQL Flexible Server.                                                                     |
| resource_group         | string           | n/a                    | yes      | The name of the resource group in which to create the MySQL Flexible Server.                                  |
| sku_name               | string           | `"GP_Standard_D4s_v3"` | no       | Specifies the SKU Name for this MySQL Flexible Server.                                                        |
| storagesize_mb         | string           | `"640000"`             | no       | Specifies the version of MySQL to use.                                                                        |
| geo_redundant_backup_enabled         | bool           | `"true"`             | no       | Specifies if Geo-Redundant backup is enabled on the MySQL Flexible Server.                                                                        |
| tags                   | map              | `"<map>"`              | no       | A mapping of tags to assign to the resource.                                                                       |

## Variables (Advanced)

| Name                         | Type   | Default             | Required | Description                                                                                            |
| ---------------------------- | ------ | ------------------- | -------- | ------------------------------------------------------------------------------------------------------ |
| kv_pointer_enable            | string | `"false"`           | no       | Flag kv_pointer_enable can either be `true` (state from key vault), or `false` (state from terraform). |
| kv_pointer_name              | string | null                | no       | The key vault name to be used when kv_pointer_enable is set to `true`.                                 |
| kv_workflow_rg               | string | null                | no       | The key vault resource group to be used when kv_pointer_enable is set to `true`.                       |
| kv_pointer_sqladmin_password | string | null                | no       | The sqladmin password to be looked up in key vault when kv_pointer_enable is set to `true`."           |
| subnet_id                      | string | null                | no       | The subnet where you want the database created. The subnet must be delegated to the Microsoft.DBforMySQL/flexibleServers service.                |
| private_dns_zone_id                  | string | null                | no       | The ID of the private DNS zone to create the MySQL Flexible Server. The private DNS zone must end with the suffix .mysql.database.azure.com.                        |

## History

| Date     | Release | Change                                                        |
| -------- | ------- | ------------------------------------------------------------- |
