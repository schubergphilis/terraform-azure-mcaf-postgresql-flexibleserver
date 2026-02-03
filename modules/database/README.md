<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.5 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 3.3.0, < 4.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.20.0, < 5.0.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | >= 1.25.0, < 2.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 3.3.0, < 4.0.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.20.0, < 5.0.0 |
| <a name="provider_postgresql.database"></a> [postgresql.database](#provider\_postgresql.database) | >= 1.25.0, < 2.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6.0, < 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_postgresql_flexible_server_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [postgresql_default_privileges.future_table_rights_admin_account](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.future_table_rights_own_role](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.local_owner_future_function_rights_admin_account](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.local_owner_future_function_rights_own_role](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.local_owner_future_sequence_rights_admin_account](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.local_owner_future_sequence_rights_own_role](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.local_owner_future_table_rights_admin_account](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.local_owner_future_table_rights_own_role](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_grant.create_usage_on_schema](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.local_owner_create_usage_on_schema](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.local_owner_database_connect](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.local_owner_function_rights](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.local_owner_sequence_rights](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.local_owner_table_rights](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.table_rights](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_role.admin](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [postgresql_role.local_owner](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [postgresql_role.reader](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [postgresql_role.writer](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [postgresql_security_label.admin](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/security_label) | resource |
| [postgresql_security_label.readers](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/security_label) | resource |
| [postgresql_security_label.writers](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/security_label) | resource |
| [random_password.local_owner](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azuread_group.admin_groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.reader_groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.writer_groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the postgresql database. | `string` | n/a | yes |
| <a name="input_postgresql_server_administrator_username"></a> [postgresql\_server\_administrator\_username](#input\_postgresql\_server\_administrator\_username) | n/a | `string` | n/a | yes |
| <a name="input_postgresql_server_id"></a> [postgresql\_server\_id](#input\_postgresql\_server\_id) | The id of the postgresql server on which to create the database. | `string` | n/a | yes |
| <a name="input_admin_groups"></a> [admin\_groups](#input\_admin\_groups) | n/a | <pre>list(object({<br/>    group_name  = string<br/>    role_prefix = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_admin_identity_object_ids"></a> [admin\_identity\_object\_ids](#input\_admin\_identity\_object\_ids) | n/a | <pre>list(object({<br/>    object_id      = string<br/>    principal_name = string<br/>    role_prefix    = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_charset"></a> [charset](#input\_charset) | The charset of the postgresql database. | `string` | `"UTF8"` | no |
| <a name="input_collation"></a> [collation](#input\_collation) | The collation of the postgresql database. | `string` | `"en_US.utf8"` | no |
| <a name="input_local_owner_account"></a> [local\_owner\_account](#input\_local\_owner\_account) | Local PostgreSQL account with owner access for applications that do not support AD authentication. Set generate\_password to false if password will be managed outside of Terraform. | <pre>object({<br/>    username          = string<br/>    generate_password = optional(bool, true)<br/>  })</pre> | `null` | no |
| <a name="input_reader_groups"></a> [reader\_groups](#input\_reader\_groups) | n/a | <pre>list(object({<br/>    role_prefix = optional(string)<br/>    group_name  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_reader_managed_identity_object_ids"></a> [reader\_managed\_identity\_object\_ids](#input\_reader\_managed\_identity\_object\_ids) | n/a | <pre>list(object({<br/>    object_id      = string<br/>    principal_name = string<br/>    role_prefix    = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_writer_groups"></a> [writer\_groups](#input\_writer\_groups) | n/a | <pre>list(object({<br/>    group_name  = string<br/>    role_prefix = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_writer_managed_identity_object_ids"></a> [writer\_managed\_identity\_object\_ids](#input\_writer\_managed\_identity\_object\_ids) | n/a | <pre>list(object({<br/>    object_id      = string<br/>    principal_name = string<br/>    role_prefix    = optional(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_local_owner_account"></a> [local\_owner\_account](#output\_local\_owner\_account) | Local PostgreSQL owner account credentials. Password is null if generate\_password was set to false. |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->