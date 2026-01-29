output "id" {
  value = azurerm_postgresql_flexible_server.this.id
}

output "fqdn" {
  value      = azurerm_postgresql_flexible_server.this.fqdn
  depends_on = [azurerm_private_endpoint.this]
}

output "administrator_username" {
  value = azurerm_postgresql_flexible_server.this.administrator_login
}

output "administrator_password" {
  value     = random_password.password.result
  sensitive = true
}
