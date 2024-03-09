# Configuration
terraform {
  backend "azurerm" {
    resource_group_name  = var.resource_group_globalinfra["name"]
    storage_account_name = var.storage_account_name
    container_name       = var.storage_container_name
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.94.0"
    }
  }
}

provider "azurerm" {
  features {}
/*
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  */
}

# Azure Resources
resource "azurerm_resource_group" "rg-globalinfra" {
  name     = var.resource_group_globalinfra["name"]
  location = var.resource_group_globalinfra["location"]
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

resource "azurerm_container_registry" "cr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg-globalinfra.name
  location            = azurerm_resource_group.rg-globalinfra.location
  sku                 = "Basic"
  admin_enabled       = true
}

/*
resource "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.rg-globalinfra.name
  location            = azurerm_resource_group.rg-globalinfra.location
  tenant_id           = var.tenant_id
  sku_name            = "standard"
}
*/