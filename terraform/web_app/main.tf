# Configuration
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-globalinfra-prod-euwest-001" # Must be deployed first
    storage_account_name = "stdolpyndata001"                # Must be deployed first
    container_name       = "terraform"                      # Must be deployed first
    key                  = "terraform.tfstate"
  }

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
resource "azurerm_resource_group" "rg-dolpyn" {
  name     = var.resource_group_dolpyn["name"]
  location = var.resource_group_dolpyn["location"]
}

resource "azurerm_service_plan" "asp" {
  name                = "ASP-rgdolpynprodeuwest001"
  resource_group_name = azurerm_resource_group.rg-dolpyn.name
  location            = azurerm_resource_group.rg-dolpyn.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "web-dolpyn" {
  name                = "dolpyn"
  resource_group_name = azurerm_resource_group.rg-dolpyn.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  app_settings = {
    "RAPID_API_KEY" = "var.rapid_api_key"
  }

  site_config {
    application_stack {
      docker_image_name        = "dolpyn:latest"
      docker_registry_url      = "https://${var.acr_name}.azurecr.io"
      docker_registry_username = var.client_id
      docker_registry_password = var.client_secret
    }
  }
}