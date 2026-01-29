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

