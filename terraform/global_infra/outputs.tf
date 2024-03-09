output "acr_admin_password" {
  description = "The password associated with the Container Registry Admin account - if the admin account is enabled"
  value       = azurerm_container_registry.cr.admin_password
  sensitive   = true
}