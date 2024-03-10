# Configuration
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-globalinfra-prod-euwest-001" # Must be deployed by hand first
    storage_account_name = "stdolpyndata001"                # Must be deployed by hand first
    container_name       = "terraform"                      # Must be deployed by hand first
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

resource "azurerm_storage_blob" "example" {
  name                   = "terraform.tfstate"
  storage_account_name   = azurerm_storage_account.st.name
  storage_container_name = azurerm_storage_container.storage-container.name
  type                   = "Block"
  source                 = "./terraform/global_infra/terraform.tfstate"
}