data "azuread_group" "active_directory_administrator_groups" {
  for_each = toset(var.active_directory_administrator_groups)

  display_name     = each.value
  security_enabled = true
}

locals {
  active_directory_administrators = concat(
    [for group in data.azuread_group.active_directory_administrator_groups :
      {
        object_id      = group.object_id
        principal_name = group.display_name
        principal_type = "Group"
      }
    ],
    [
      {
        object_id      = data.azurerm_client_config.current.object_id
        principal_name = var.tf_azurerm_mid_name
        principal_type = "ServicePrincipal"
      }
    ]
  )
  storage_mb = var.storage_size * 1024
}
