output "id" {
  value = azurerm_postgresql_flexible_server.this.id
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "administrator_username" {
  value = azurerm_postgresql_flexible_server.this.administrator_login
}

output "administrator_password" {
  value     = random_password.password.result
  sensitive = true
}

output "databases" {
  description = "Map of database names to their details including local owner account credentials."
  sensitive   = true
  value = {
    for name, db in module.database : name => {
      id                  = db.id
      name                = db.name
      local_owner_account = db.local_owner_account
    }
  }
}
