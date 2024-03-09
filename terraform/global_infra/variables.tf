# Azure secrets
variable "subscription_id" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}


# Azure Resources
variable "resource_group_globalinfra" {
  type = map(string)
  default = {
    name     = "rg-globalinfra-prod-euwest-001"
    location = "westeurope"
  }
}

variable "container_registry_name" {
  default = ""
}

variable "key_vault_name" {
  default = "kv-globalinfra"
}