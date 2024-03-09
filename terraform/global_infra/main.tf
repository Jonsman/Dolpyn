# Provider Configuration
terraform {
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

# add blob storage for terraform state

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