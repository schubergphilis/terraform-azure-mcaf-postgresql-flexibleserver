# Basic Example
# This example demonstrates a minimal configuration for the PostgreSQL Flexible Server module.

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
  name     = "rg-postgresql-example"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-postgresql-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "snet-postgresql-example"
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

resource "azurerm_user_assigned_identity" "example" {
  name                = "mi-postgresql-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_key_vault" "example" {
  name                       = "kv-postgresql-example"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
}

resource "azurerm_key_vault_key" "example" {
  name         = "key-postgresql-example"
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

  name                = "psql-example-basic"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  sku          = "GP_Standard_D2s_v3"
  storage_size = 32
  subnet_id    = azurerm_subnet.example.id

  customer_managed_key = {
    key_vault_key_id                  = azurerm_key_vault_key.example.id
    primary_user_assigned_identity_id = azurerm_user_assigned_identity.example.id
  }

  tf_azurerm_mid_name = azurerm_user_assigned_identity.example.name
}
