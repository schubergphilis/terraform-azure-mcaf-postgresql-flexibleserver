# Complete Example
# This example demonstrates a full configuration for the PostgreSQL Flexible Server module
# with multiple databases and role-based access control.

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.25.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "postgresql" {
  alias           = "database"
  host            = module.postgresql.fqdn
  port            = 5432
  username        = module.postgresql.administrator_username
  password        = module.postgresql.administrator_password
  sslmode         = "require"
  connect_timeout = 15
  superuser       = false
}

resource "azurerm_resource_group" "example" {
  name     = "rg-postgresql-complete"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-postgresql-complete"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "snet-postgresql-complete"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "postgresql-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_user_assigned_identity" "postgresql" {
  name                = "mi-postgresql-complete"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_user_assigned_identity" "app" {
  name                = "mi-app-complete"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_key_vault" "example" {
  name                       = "kv-psql-complete"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
}

resource "azurerm_key_vault_key" "example" {
  name         = "key-postgresql-complete"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

data "azurerm_client_config" "current" {}

module "postgresql" {
  source = "../../"

  providers = {
    postgresql.database = postgresql.database
  }

  name                = "psql-example-complete"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  # Server configuration
  sku                   = "GP_Standard_D4s_v3"
  storage_size          = 128
  server_version        = "15"
  backup_retention_days = 14
  subnet_id             = azurerm_subnet.example.id

  # High availability configuration
  high_available                 = true
  high_availability_mode         = "ZoneRedundant"
  high_availability_standby_zone = "2"

  # Authentication configuration
  password_auth_enabled         = true
  active_directory_auth_enabled = true

  # Network configuration
  public_network_access_enabled        = false
  private_service_connection_is_manual = false

  # Customer-managed key
  customer_managed_key = {
    key_vault_key_id                  = azurerm_key_vault_key.example.id
    primary_user_assigned_identity_id = azurerm_user_assigned_identity.postgresql.id
  }

  tf_azurerm_mid_name = azurerm_user_assigned_identity.postgresql.name

  # Active Directory administrator groups
  active_directory_administrator_groups = [
    "PostgreSQL-Admins"
  ]

  # Databases with role-based access control
  databases = {
    "app_production" = {
      charset   = "UTF8"
      collation = "en_US.utf8"

      admin_groups = [
        {
          group_name  = "Database-Admins"
          role_prefix = "admin"
        }
      ]

      writer_managed_identity_object_ids = [
        {
          object_id      = azurerm_user_assigned_identity.app.principal_id
          principal_name = azurerm_user_assigned_identity.app.name
          role_prefix    = "app"
        }
      ]

      reader_groups = [
        {
          group_name  = "Data-Analysts"
          role_prefix = "analyst"
        }
      ]
    }

    "app_staging" = {
      charset   = "UTF8"
      collation = "en_US.utf8"

      writer_groups = [
        {
          group_name  = "Developers"
          role_prefix = "dev"
        }
      ]
    }

    "analytics" = {
      charset   = "UTF8"
      collation = "en_US.utf8"

      reader_groups = [
        {
          group_name  = "Data-Analysts"
          role_prefix = "analyst"
        },
        {
          group_name  = "BI-Team"
          role_prefix = "bi"
        }
      ]

      admin_groups = [
        {
          group_name  = "Data-Engineers"
          role_prefix = "engineer"
        }
      ]
    }
  }
}
