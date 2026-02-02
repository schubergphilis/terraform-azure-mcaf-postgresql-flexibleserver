terraform {
  required_version = ">= 1.8.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.20.0, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.3, < 4.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.3.0, < 4.0.0"
    }
    postgresql = {
      source                = "cyrilgdn/postgresql"
      version               = ">= 1.25.0, < 2.0.0"
      configuration_aliases = [postgresql.database]
    }
  }
}
