variable "resource_group_globalinfra" {
  type = map(string)
  default = {
    name     = "rg-globalinfra-prod-euwest-001"
    location = "westeurope"
  }
}

variable "resource_group_dolpyn" {
  type = map(string)
  default = {
    name     = "rg-dolpyn-prod-euwest-001"
    location = "westeurope"
  }
}

variable "container_registry_name" {
  default = "crglobalinfraprod001"
}

variable "container_app_environment_name" {
  default = "cae-dolpyn-prod-euwest-001"
}

variable "container_app_name" {
  default = "ca-dolpyn-prod-euwest-001"
}