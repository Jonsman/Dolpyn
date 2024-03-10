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
      version = "3.94.0"
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
  #revision_mode                = "Multiple"
  revision_mode = "Single"

  ingress {
    target_port      = 5000
    external_enabled = true
    transport = auto

    traffic_weight {
      latest_revision = true
      percentage = 100
    }
  }

  template {
    container {
      name = "dolpyn"
      #image  = "${var.acr_name}.azurecr.io/dolpyn:latest"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}