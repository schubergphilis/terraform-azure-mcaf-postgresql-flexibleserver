resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.name
  server_id = var.postgresql_server_id
  collation = var.collation
  charset   = var.charset
}

resource "postgresql_role" "reader" {
  provider = postgresql.database
  for_each = local.readers

  name  = each.value.role_name
  login = true
  roles = ["pg_read_all_data"]

  depends_on = [azurerm_postgresql_flexible_server_database.this]
}

resource "postgresql_role" "writer" {
  provider = postgresql.database
  for_each = local.writers

  name  = each.value.role_name
  login = true
  roles = ["pg_read_all_data", "pg_write_all_data"]

  depends_on = [azurerm_postgresql_flexible_server_database.this]
}

resource "postgresql_role" "admin" {
  provider = postgresql.database
  for_each = local.admins

  name  = each.value.role_name
  login = true
  roles = ["pg_read_all_data", "pg_write_all_data"]

  depends_on = [azurerm_postgresql_flexible_server_database.this]
}

resource "postgresql_grant" "create_usage_on_schema" {
  provider = postgresql.database
  for_each = local.admins

  database    = azurerm_postgresql_flexible_server_database.this.name
  role        = postgresql_role.admin[each.key].name
  object_type = "schema"
  objects     = []
  privileges  = ["USAGE", "CREATE"]
  schema      = "public"
}

resource "postgresql_grant" "table_rights" {
  provider = postgresql.database
  for_each = local.admins

  database    = azurerm_postgresql_flexible_server_database.this.name
  role        = postgresql_role.admin[each.key].name
  object_type = "table"
  schema      = "public"
  privileges  = ["ALL"]
}

# As default privileges are based on the executor this should be a matrix of all accounts with DDL permissions
# its not right now and I will leave it for future iteration of this module.
resource "postgresql_default_privileges" "future_table_rights_own_role" {
  provider = postgresql.database
  for_each = local.admins

  database    = azurerm_postgresql_flexible_server_database.this.name
  schema      = "public"
  owner       = postgresql_role.admin[each.key].name
  object_type = "table"
  privileges  = ["ALL"]
  role        = postgresql_role.admin[each.key].name
}

resource "postgresql_default_privileges" "future_table_rights_admin_account" {
  provider = postgresql.database
  for_each = local.admins

  database    = azurerm_postgresql_flexible_server_database.this.name
  schema      = "public"
  owner       = var.postgresql_server_administrator_username
  object_type = "table"
  privileges  = ["ALL"]
  role        = postgresql_role.admin[each.key].name
}

resource "postgresql_security_label" "readers" {
  provider = postgresql.database
  for_each = local.readers

  object_type    = "role"
  object_name    = postgresql_role.reader[each.key].name
  label_provider = "pgaadauth"
  label          = "aadauth,oid=${each.value.object_id},type=${each.value.type}"

  depends_on = [azurerm_postgresql_flexible_server_database.this]
}

resource "postgresql_security_label" "writers" {
  provider = postgresql.database
  for_each = local.writers

  object_type    = "role"
  object_name    = postgresql_role.writer[each.key].name
  label_provider = "pgaadauth"
  label          = "aadauth,oid=${each.value.object_id},type=${each.value.type}"

  depends_on = [azurerm_postgresql_flexible_server_database.this]
}

resource "postgresql_security_label" "admin" {
  provider = postgresql.database
  for_each = local.admins

  object_type    = "role"
  object_name    = postgresql_role.admin[each.key].name
  label_provider = "pgaadauth"
  label          = "aadauth,oid=${each.value.object_id},type=${each.value.type}"

  depends_on = [azurerm_postgresql_flexible_server_database.this]
}

# Local owner account for applications that do not support AD authentication
resource "random_password" "local_owner" {
  count = local.generate_owner_password ? 1 : 0

  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "postgresql_role" "local_owner" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  name     = var.local_owner_account.username
  login    = true
  password = local.generate_owner_password ? random_password.local_owner[0].result : null

  # Security hardening - principle of least privilege
  superuser       = false
  create_database = false
  create_role     = false
  inherit         = true
  replication     = false

  depends_on = [azurerm_postgresql_flexible_server_database.this]
}

resource "postgresql_grant" "local_owner_database_connect" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  role        = postgresql_role.local_owner[0].name
  object_type = "database"
  privileges  = ["CONNECT"]
}

resource "postgresql_grant" "local_owner_create_usage_on_schema" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  role        = postgresql_role.local_owner[0].name
  object_type = "schema"
  objects     = []
  privileges  = ["USAGE", "CREATE"]
  schema      = "public"
}

resource "postgresql_grant" "local_owner_table_rights" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  role        = postgresql_role.local_owner[0].name
  object_type = "table"
  schema      = "public"
  privileges  = ["ALL"]
}

resource "postgresql_grant" "local_owner_sequence_rights" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  role        = postgresql_role.local_owner[0].name
  object_type = "sequence"
  schema      = "public"
  privileges  = ["ALL"]
}

resource "postgresql_grant" "local_owner_function_rights" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  role        = postgresql_role.local_owner[0].name
  object_type = "function"
  schema      = "public"
  privileges  = ["ALL"]
}

resource "postgresql_default_privileges" "local_owner_future_table_rights_own_role" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  schema      = "public"
  owner       = postgresql_role.local_owner[0].name
  object_type = "table"
  privileges  = ["ALL"]
  role        = postgresql_role.local_owner[0].name
}

resource "postgresql_default_privileges" "local_owner_future_table_rights_admin_account" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  schema      = "public"
  owner       = var.postgresql_server_administrator_username
  object_type = "table"
  privileges  = ["ALL"]
  role        = postgresql_role.local_owner[0].name
}

resource "postgresql_default_privileges" "local_owner_future_sequence_rights_own_role" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  schema      = "public"
  owner       = postgresql_role.local_owner[0].name
  object_type = "sequence"
  privileges  = ["ALL"]
  role        = postgresql_role.local_owner[0].name
}

resource "postgresql_default_privileges" "local_owner_future_sequence_rights_admin_account" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  schema      = "public"
  owner       = var.postgresql_server_administrator_username
  object_type = "sequence"
  privileges  = ["ALL"]
  role        = postgresql_role.local_owner[0].name
}

resource "postgresql_default_privileges" "local_owner_future_function_rights_own_role" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  schema      = "public"
  owner       = postgresql_role.local_owner[0].name
  object_type = "function"
  privileges  = ["ALL"]
  role        = postgresql_role.local_owner[0].name
}

resource "postgresql_default_privileges" "local_owner_future_function_rights_admin_account" {
  provider = postgresql.database
  count    = local.create_local_owner ? 1 : 0

  database    = azurerm_postgresql_flexible_server_database.this.name
  schema      = "public"
  owner       = var.postgresql_server_administrator_username
  object_type = "function"
  privileges  = ["ALL"]
  role        = postgresql_role.local_owner[0].name
}

