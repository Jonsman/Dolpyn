# Provider Configuration
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

  site_config {
    application_stack {
      docker_image_name   = "dolpyn:latest"
      docker_registry_url = "https://${var.acr_name}.azurecr.io"
      docker_registry_username = var.client_id
      docker_registry_password = var.client_secret
    }
  }
}

/*
resource "azurerm_log_analytics_workspace" "log" {
  name                = var.log_analytics_workspace_name
  resource_group_name = azurerm_resource_group.rg-dolpyn.name
  location            = azurerm_resource_group.rg-dolpyn.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "cae" {
  name                       = var.container_app_environment_name
  resource_group_name        = azurerm_resource_group.rg-dolpyn.name
  location                   = azurerm_resource_group.rg-dolpyn.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

resource "azurerm_container_app" "ca" {
  name                         = var.container_app_name
  resource_group_name          = var.resource_group_dolpyn["name"]
  container_app_environment_id = azurerm_container_app_environment.cae.id
  revision_mode                = "Single"

  ingress {
    target_port      = 5000
    external_enabled = true

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    container {
      name = "dolpyn"
      image  = "${var.acr_name}.azurecr.io/dolpyn:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}
*/