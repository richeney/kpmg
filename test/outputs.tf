output "app_id" {
  value       = azuread_application.sp.application_id
  description = "The app ID links the app registration to the service principal."
}

output "app_object_id" {
  value       = azuread_application.sp.object_id
  description = "The AAD object ID for the app registration."
}

output "sp_object_id" {
  value       = azuread_service_principal.sp.id
  description = "The AAD object ID for the service principal."
}

output "secret" {
  value       = random_string.sp_password.result
  description = "The password for the service principal."
  sensitive   = true
}

output "oauth2_permissions" {
  value       = azuread_application.sp.oauth2_permissions
  description = "See https://www.terraform.io/docs/providers/azuread/r/application.html#oauth2_permissions"
}
