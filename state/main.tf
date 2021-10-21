terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "swampdog-terraform"
      storage_account_name = "swampdogterraformstate"
      container_name       = "state"
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = "Central US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = "spc"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "spc"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "state" {
  name                  = "state"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}