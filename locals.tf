data "azuread_group" "active_directory_administrator_groups" {
  for_each = toset(var.active_directory_administrator_groups)

  display_name     = each.value
  security_enabled = true
}

locals {
  storage_mb = var.storage_size * 1024
}
