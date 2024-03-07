# Provider Configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.94.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "//./pipe/docker_engine"
}

provider "azurerm" {
  features {}

  subscription_id = ""      # Fill in your subscription ID
  tenant_id       = ""      # Fill in your tenant ID
  client_id       = ""      # Fill in your client ID
  client_secret   = ""      # Fill in your client secret
}

/*
# Docker Resources
resource "docker_image" "dockerdolpyn" {
  name = "dolpyn"
  build {
    context = "."
  }
}

resource "docker_tag" "dockerdolpyntag" {
  source_image = docker_image.dockerdolpyn.latest
  target_image = "${var.container_registry_name}/dolpyn:latest"
}
*/

# Azure Resources
resource "azurerm_resource_group" "rg-globalinfra" {
  name     = var.resource_group_globalinfra["name"]
  location = var.resource_group_globalinfra["location"]
}

resource "azurerm_container_registry" "cr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg-globalinfra.name
  location            = azurerm_resource_group.rg-globalinfra.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_resource_group" "rg-dolpyn" {
  name     = var.resource_group_dolpyn["name"]
  location = var.resource_group_dolpyn["location"]
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "acctest-01"
  resource_group_name = azurerm_resource_group.rg-dolpyn.name
  location            = azurerm_resource_group.rg-dolpyn.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "cae" {
  name                       = var.container_app_environment_name
  resource_group_name        = var.resource_group_dolpyn["name"]
  location                   = var.resource_group_dolpyn["location"]
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

/*
resource "azurerm_container_app" "ca" {
  name                         = var.container_app_name
  resource_group_name          = var.resource_group_dolpyn["name"]
  container_app_environment_id = azurerm_container_app_environment.cae.id
  revision_mode                = "Multiple"

  ingress {
    target_port      = 5000
    external_enabled = true

    traffic_weight {
      percentage = 100
    }
  }

  template {
    container {
      name   = "dolpyn"
      image  = "crglobalinfraprod001/dolpyn"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}
*/