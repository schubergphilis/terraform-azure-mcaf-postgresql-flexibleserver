variable "name" {
  type        = string
  description = "The name of the postgresql server."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the postgresql server will be created."
}

variable "location" {
  type        = string
  description = "The location of the postgresql server."
}

variable "active_directory_administrator_groups" {
  type    = list(string)
  default = []
}

variable "administrator_username" {
  type    = string
  default = "sbp_administrator"
}

variable "backup_retention_days" {
  type        = number
  description = "Number of days to keep the postgress backup, between 7 and 35"
  default     = 7
}

variable "customer_managed_key" {
  type = object({
    key_vault_key_id                  = string
    primary_user_assigned_identity_id = string
  })
  description = "CMK configuration for the postgresql server."
}

variable "high_available" {
  type        = bool
  description = "Whether the postgresql server should be HA."
  default     = true
}

variable "server_version" {
  type        = string
  description = "The version of the postgresql server. "
  default     = "14"
}

variable "sku" {
  type        = string
  description = "The sku of the postgresql server. "
}

variable "storage_size" {
  type        = number
  description = "The max storage allowed for the PostgreSQL Flexible Server in GB. Possible values are 32, 64, 128, 256, 512, 1024, 2048, 4095, 4096, 8192, 16384, and 32767."
  default     = 32
}

variable "delegated_subnet_id" {
  type        = string
  description = "The ID of the delegated subnet for the PostgreSQL Flexible Server. This subnet must have the 'Microsoft.DBforPostgreSQL/flexibleServers' service delegation."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "The ID of the private DNS zone for the PostgreSQL Flexible Server. Required when using a delegated subnet."
  default     = null
}

variable "use_password_override_special" {
  description = "Set true to use '!#$&()-_=+[]{}?' as special characters, false for default behavior."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is enabled for the PostgreSQL Flexible Server."
  default     = false
}

variable "password_auth_enabled" {
  type        = bool
  description = "Whether password authentication is enabled for the PostgreSQL Flexible Server."
  default     = true
}

variable "active_directory_auth_enabled" {
  type        = bool
  description = "Whether Active Directory authentication is enabled for the PostgreSQL Flexible Server."
  default     = true
}

variable "identity_type" {
  type        = string
  description = "The type of identity to use for the PostgreSQL Flexible Server. Possible values are 'UserAssigned' or 'SystemAssigned'."
  default     = "UserAssigned"
}

variable "high_availability_mode" {
  type        = string
  description = "The high availability mode for the PostgreSQL Flexible Server. Possible values are 'ZoneRedundant' or 'SameZone'."
  default     = "ZoneRedundant"
}

variable "high_availability_standby_zone" {
  type        = string
  description = "The availability zone for the standby server when high availability is enabled."
  default     = "2"
}

variable "private_service_connection_is_manual" {
  type        = bool
  description = "Whether the private service connection requires manual approval."
  default     = false
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Whether geo-redundant backup is enabled for the PostgreSQL Flexible Server."
  default     = true
}

variable "databases" {
  type = map(object({
    charset                = optional(string, "UTF8")
    collation              = optional(string, "en_US.utf8")
    administrator_username = optional(string)

    local_owner_account = optional(object({
      username          = string
      generate_password = optional(bool, true)
    }))

    reader_groups = optional(list(object({
      group_name  = string
      role_prefix = optional(string)
    })), [])

    reader_managed_identity_object_ids = optional(list(object({
      object_id      = string
      principal_name = string
      role_prefix    = optional(string)
    })), [])

    writer_groups = optional(list(object({
      group_name  = string
      role_prefix = optional(string)
    })), [])

    writer_managed_identity_object_ids = optional(list(object({
      object_id      = string
      principal_name = string
      role_prefix    = optional(string)
    })), [])

    admin_groups = optional(list(object({
      group_name  = string
      role_prefix = optional(string)
    })), [])

    admin_identity_object_ids = optional(list(object({
      object_id      = string
      principal_name = string
      role_prefix    = optional(string)
    })), [])
  }))
  default     = {}
  description = <<-DOC
    A map of databases to create on the PostgreSQL Flexible Server. The map key is used as the database name.

    Each database object supports the following properties:
    - `charset`              - (Optional) The charset of the PostgreSQL database. Defaults to `UTF8`.
    - `collation`            - (Optional) The collation of the PostgreSQL database. Defaults to `en_US.utf8`.
    - `administrator_username` - (Optional) The administrator username for the PostgreSQL server. If not specified, the server's default administrator username is used.

    - `reader_groups` - (Optional) A list of Entra ID groups to grant read access to the database.
      - `group_name`  - (Required) The name of the Entra ID group.
      - `role_prefix` - (Optional) A prefix for the database role name.

    - `reader_managed_identity_object_ids` - (Optional) A list of managed identities to grant read access to the database.
      - `object_id`      - (Required) The object ID of the managed identity.
      - `principal_name` - (Required) The principal name of the managed identity.
      - `role_prefix`    - (Optional) A prefix for the database role name.

    - `writer_groups` - (Optional) A list of Entra ID groups to grant write access to the database.
      - `group_name`  - (Required) The name of the Entra ID group.
      - `role_prefix` - (Optional) A prefix for the database role name.

    - `writer_managed_identity_object_ids` - (Optional) A list of managed identities to grant write access to the database.
      - `object_id`      - (Required) The object ID of the managed identity.
      - `principal_name` - (Required) The principal name of the managed identity.
      - `role_prefix`    - (Optional) A prefix for the database role name.

    - `admin_groups` - (Optional) A list of Entra ID groups to grant admin access to the database.
      - `group_name`  - (Required) The name of the Entra ID group.
      - `role_prefix` - (Optional) A prefix for the database role name.

    - `admin_identity_object_ids` - (Optional) A list of managed identities to grant admin access to the database.
      - `object_id`      - (Required) The object ID of the managed identity.
      - `principal_name` - (Required) The principal name of the managed identity.
      - `role_prefix`    - (Optional) A prefix for the database role name.

    - `local_owner_account` - (Optional) A local PostgreSQL account with owner access for applications that do not support AD authentication.
      - `username`          - (Required) The username for the local account.
      - `generate_password` - (Optional) Whether to auto-generate a password. Defaults to `true`. Set to `false` if password will be managed outside of Terraform.
  DOC
}
