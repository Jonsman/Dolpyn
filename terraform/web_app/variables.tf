variable "resource_group_dolpyn" {
  type = map(string)
  default = {
    name     = "rg-dolpyn-prod-euwest-001"
    location = "westeurope"
  }
}

variable "acr_name" {
  description = "container registry name"
  type        = string
}

variable "client_id" {
  description = "sevice principle client id"
  type        = string
}

variable "client_secret" {
  description = "service principle client secret"
  type        = string
}

variable "rapid_api_key" {
  description = "rapid api key"
  type        = string
}