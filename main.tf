data "azurerm_client_config" "current" {}

resource "azurerm_postgresql_flexible_server" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login           = var.administrator_username
  administrator_password        = random_password.password.result
  backup_retention_days         = var.backup_retention_days
  create_mode                   = "Default" # TODO: support DR scenarios
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  public_network_access_enabled = var.public_network_access_enabled
  sku_name                      = var.sku
  storage_mb                    = local.storage_mb
  geo_redundant_backup_enabled  = var.geo_redundant_backup_enabled
  version                       = var.server_version
  zone                          = var.high_available ? "1" : null

  authentication {
    password_auth_enabled         = var.password_auth_enabled
    active_directory_auth_enabled = var.active_directory_auth_enabled
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }

  identity {
    type         = var.identity_type
    identity_ids = [var.customer_managed_key.primary_user_assigned_identity_id]
  }

  customer_managed_key {
    key_vault_key_id                  = var.customer_managed_key.key_vault_key_id
    primary_user_assigned_identity_id = var.customer_managed_key.primary_user_assigned_identity_id
  }

  dynamic "high_availability" {
    for_each = var.high_available ? [true] : []
    content {
      mode                      = var.high_availability_mode
      standby_availability_zone = var.high_availability_standby_zone
    }
  }

  lifecycle {
    ignore_changes = [
      zone,
      high_availability
    ]
  }
}

resource "random_password" "password" {
  length           = 48
  special          = true
  override_special = var.use_password_override_special ? "!#$&()-_=+[]{}?" : null
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "this" {
  for_each = { for v in local.active_directory_administrators : v.object_id => v }

  server_name         = azurerm_postgresql_flexible_server.this.name
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = each.value.object_id
  principal_name      = each.value.principal_name
  principal_type      = each.value.principal_type
}

module "database" {
  for_each = var.databases

  source = "./modules/database"

  providers = {
    postgresql.database = postgresql.database
  }

  postgresql_server_id                     = azurerm_postgresql_flexible_server.this.id
  name                                     = each.key
  postgresql_server_administrator_username = each.value.administrator_username

}