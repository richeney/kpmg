output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "client_id" {
  value = azuread_application.spcreator.application_id
}

output "client_secret" {
  value = random_string.spcreator_password.result
}

output "name" {
  value = "http://service_principal_creator"
}

output "displayName" {
  value = "service_principal_creator"
}
