variable "resource_group_globalinfra" {
  type = map(string)
  default = {
    name     = "rg-globalinfra-prod-euwest-001"
    location = "westeurope"
  }
}

variable "storage_account_name" {
  default = "stdolpyndata001"
}

variable "storage_container_name" {
  default = "terraform"
}