# Configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Azure Resources
resource "azurerm_resource_group" "rg-globalinfra" {
  name     = var.resource_group_globalinfra["name"]
  location = var.resource_group_globalinfra["location"]
}

resource "azurerm_container_registry" "cr" {
  name                = var.container_registry
  resource_group_name = azurerm_resource_group.rg-globalinfra.name
  location            = azurerm_resource_group.rg-globalinfra.location
  sku                 = "Basic"
  admin_enabled       = true

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_account" "st" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg-globalinfra.name
  location                 = azurerm_resource_group.rg-globalinfra.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage-container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.st.name
  container_access_type = "private"
}