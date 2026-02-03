data "azuread_group" "reader_groups" {
  for_each = { for group in var.reader_groups : group.group_name => group }

  display_name     = each.key
  security_enabled = true
}

data "azuread_group" "writer_groups" {
  for_each = { for group in var.writer_groups : group.group_name => group }

  display_name     = each.key
  security_enabled = true
}

data "azuread_group" "admin_groups" {
  for_each = { for group in var.admin_groups : group.group_name => group }

  display_name     = each.key
  security_enabled = true
}

locals {
  readers = merge(
    { for group in var.reader_groups : data.azuread_group.reader_groups[group.group_name].object_id =>
      {
        role_name = "${group.role_prefix != null ? group.role_prefix : data.azuread_group.reader_groups[group.group_name].display_name}_group_reader"
        object_id = data.azuread_group.reader_groups[group.group_name].object_id
        type      = "group"
      }
    },
    { for mid in var.reader_managed_identity_object_ids : mid.object_id =>
      {
        role_name = "${mid.role_prefix != null ? mid.role_prefix : mid.principal_name}_service_reader"
        object_id = mid.object_id
        type      = "service"
      }
    }
  )

  writers = merge(
    { for group in var.writer_groups : data.azuread_group.writer_groups[group.group_name].object_id =>
      {
        role_name = "${group.role_prefix != null ? group.role_prefix : data.azuread_group.writer_groups[group.group_name].display_name}_group_writer"
        object_id = data.azuread_group.writer_groups[group.group_name].object_id
        type      = "group"
      }
    },
    { for mid in var.writer_managed_identity_object_ids : mid.object_id =>
      {
        role_name = "${mid.role_prefix != null ? mid.role_prefix : mid.principal_name}_service_writer"
        object_id = mid.object_id
        type      = "service"
      }
    }
  )

  admins = merge(
    { for group in var.admin_groups : data.azuread_group.admin_groups[group.group_name].object_id =>
      {
        role_name = "${group.role_prefix != null ? group.role_prefix : data.azuread_group.admin_groups[group.group_name].display_name}_group_admin"
        object_id = data.azuread_group.admin_groups[group.group_name].object_id
        type      = "group"
      }
    },
    { for mid in var.admin_identity_object_ids : mid.object_id =>
      {
        role_name = "${mid.role_prefix != null ? mid.role_prefix : mid.principal_name}_service_admin"
        object_id = mid.object_id
        type      = "service"
      }
    }
  )

  create_local_owner    = var.local_owner_account != null
  generate_owner_password = local.create_local_owner && var.local_owner_account.generate_password
}
