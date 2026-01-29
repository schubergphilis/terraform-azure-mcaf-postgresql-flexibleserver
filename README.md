# Introduction  
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
TODO: Describe and show how to build your code and run the tests. 

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)

- [Chakra Core](https://github.com/Microsoft/ChakraCore)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.5 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 3.3.0, < 4.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.20.0, < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.3, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 3.3.0, < 4.0.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.20.0, < 5.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6.3, < 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_postgresql_flexible_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_active_directory_administrator.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_active_directory_administrator) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azuread_group.active_directory_administrator_groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | CMK configuration for the postgresql server. | <pre>object({<br/>    key_vault_key_id                  = string<br/>    primary_user_assigned_identity_id = string<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the postgresql server. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the postgresql server. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the postgresql server will be created. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku of the postgresql server. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet id to use for the private endpoint of the postgresql server. | `string` | n/a | yes |
| <a name="input_tf_azurerm_mid_name"></a> [tf\_azurerm\_mid\_name](#input\_tf\_azurerm\_mid\_name) | n/a | `string` | n/a | yes |
| <a name="input_active_directory_administrator_groups"></a> [active\_directory\_administrator\_groups](#input\_active\_directory\_administrator\_groups) | n/a | `list(string)` | `[]` | no |
| <a name="input_active_directory_auth_enabled"></a> [active\_directory\_auth\_enabled](#input\_active\_directory\_auth\_enabled) | Whether Active Directory authentication is enabled for the PostgreSQL Flexible Server. | `bool` | `true` | no |
| <a name="input_administrator_username"></a> [administrator\_username](#input\_administrator\_username) | n/a | `string` | `"sbp_administrator"` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Number of days to keep the postgress backup, between 7 and 35 | `number` | `7` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | A map of databases to create on the PostgreSQL Flexible Server. The map key is used as the database name.<br/><br/>Each database object supports the following properties:<br/>- `charset`              - (Optional) The charset of the PostgreSQL database. Defaults to `UTF8`.<br/>- `collation`            - (Optional) The collation of the PostgreSQL database. Defaults to `en_US.utf8`.<br/>- `administrator_username` - (Optional) The administrator username for the PostgreSQL server. If not specified, the server's default administrator username is used.<br/><br/>- `reader_groups` - (Optional) A list of Entra ID groups to grant read access to the database.<br/>  - `group_name`  - (Required) The name of the Entra ID group.<br/>  - `role_prefix` - (Optional) A prefix for the database role name.<br/><br/>- `reader_managed_identity_object_ids` - (Optional) A list of managed identities to grant read access to the database.<br/>  - `object_id`      - (Required) The object ID of the managed identity.<br/>  - `principal_name` - (Required) The principal name of the managed identity.<br/>  - `role_prefix`    - (Optional) A prefix for the database role name.<br/><br/>- `writer_groups` - (Optional) A list of Entra ID groups to grant write access to the database.<br/>  - `group_name`  - (Required) The name of the Entra ID group.<br/>  - `role_prefix` - (Optional) A prefix for the database role name.<br/><br/>- `writer_managed_identity_object_ids` - (Optional) A list of managed identities to grant write access to the database.<br/>  - `object_id`      - (Required) The object ID of the managed identity.<br/>  - `principal_name` - (Required) The principal name of the managed identity.<br/>  - `role_prefix`    - (Optional) A prefix for the database role name.<br/><br/>- `admin_groups` - (Optional) A list of Entra ID groups to grant admin access to the database.<br/>  - `group_name`  - (Required) The name of the Entra ID group.<br/>  - `role_prefix` - (Optional) A prefix for the database role name.<br/><br/>- `admin_identity_object_ids` - (Optional) A list of managed identities to grant admin access to the database.<br/>  - `object_id`      - (Required) The object ID of the managed identity.<br/>  - `principal_name` - (Required) The principal name of the managed identity.<br/>  - `role_prefix`    - (Optional) A prefix for the database role name. | <pre>map(object({<br/>    charset            = optional(string, "UTF8")<br/>    collation          = optional(string, "en_US.utf8")<br/>    administrator_username = optional(string)<br/><br/>    reader_groups = optional(list(object({<br/>      group_name  = string<br/>      role_prefix = optional(string)<br/>    })), [])<br/><br/>    reader_managed_identity_object_ids = optional(list(object({<br/>      object_id      = string<br/>      principal_name = string<br/>      role_prefix    = optional(string)<br/>    })), [])<br/><br/>    writer_groups = optional(list(object({<br/>      group_name  = string<br/>      role_prefix = optional(string)<br/>    })), [])<br/><br/>    writer_managed_identity_object_ids = optional(list(object({<br/>      object_id      = string<br/>      principal_name = string<br/>      role_prefix    = optional(string)<br/>    })), [])<br/><br/>    admin_groups = optional(list(object({<br/>      group_name  = string<br/>      role_prefix = optional(string)<br/>    })), [])<br/><br/>    admin_identity_object_ids = optional(list(object({<br/>      object_id      = string<br/>      principal_name = string<br/>      role_prefix    = optional(string)<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_high_availability_mode"></a> [high\_availability\_mode](#input\_high\_availability\_mode) | The high availability mode for the PostgreSQL Flexible Server. Possible values are 'ZoneRedundant' or 'SameZone'. | `string` | `"ZoneRedundant"` | no |
| <a name="input_high_availability_standby_zone"></a> [high\_availability\_standby\_zone](#input\_high\_availability\_standby\_zone) | The availability zone for the standby server when high availability is enabled. | `string` | `"2"` | no |
| <a name="input_high_available"></a> [high\_available](#input\_high\_available) | Whether the postgresql server should be HA. | `bool` | `true` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of identity to use for the PostgreSQL Flexible Server. Possible values are 'UserAssigned' or 'SystemAssigned'. | `string` | `"UserAssigned"` | no |
| <a name="input_password_auth_enabled"></a> [password\_auth\_enabled](#input\_password\_auth\_enabled) | Whether password authentication is enabled for the PostgreSQL Flexible Server. | `bool` | `true` | no |
| <a name="input_private_service_connection_is_manual"></a> [private\_service\_connection\_is\_manual](#input\_private\_service\_connection\_is\_manual) | Whether the private service connection requires manual approval. | `bool` | `false` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is enabled for the PostgreSQL Flexible Server. | `bool` | `false` | no |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version) | The version of the postgresql server. | `string` | `"14"` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | The max storage allowed for the PostgreSQL Flexible Server in GB. Possible values are 32, 64, 128, 256, 512, 1024, 2048, 4095, 4096, 8192, 16384, and 32767. | `number` | `32` | no |
| <a name="input_use_password_override_special"></a> [use\_password\_override\_special](#input\_use\_password\_override\_special) | Set true to use '!#$&()-\_=+[]{}?' as special characters, false for default behavior. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_administrator_password"></a> [administrator\_password](#output\_administrator\_password) | n/a |
| <a name="output_administrator_username"></a> [administrator\_username](#output\_administrator\_username) | n/a |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->