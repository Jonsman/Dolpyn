variable "resource_group_dolpyn" {
  type = map(string)
  default = {
    name     = "rg-dolpyn-prod-euwest-001"
    location = "westeurope"
  }
}

variable "log_analytics_workspace_name" {
  default = "log-dolpyn-prod-euwest-001"
}

variable "container_app_environment_name" {
  default = "cae-dolpyn-prod-euwest-001"
}

variable "container_app_name" {
  default = "ca-dolpyn-prod-euwest-001"
}

variable "acr_name" {
  description = "value"
  type = string
}