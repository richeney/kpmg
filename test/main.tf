data "azurerm_client_config" "current" {
}

locals {
  subscriptions = length(var.subscriptions) > 0 ? var.subscriptions : [data.azurerm_client_config.current.subscription_id]
}

resource "azuread_application" "sp" {
  provider = azuread.spcreator
  name     = var.service_principal_name
}

resource "azuread_service_principal" "sp" {
  provider = azuread.spcreator

  application_id = azuread_application.sp.application_id
}

resource "random_string" "sp_password" {
  length  = 16
  special = true
  keepers = {
    service_principal = azuread_service_principal.sp.id
  }
}

resource "azuread_service_principal_password" "sp_password" {
  provider = azuread.spcreator

  service_principal_id = azuread_service_principal.sp.id
  value                = random_string.sp_password.result
  end_date             = timeadd(timestamp(), "8760h")
  # Valid for a year
  # Lifecycle stops end_date being recalculated on each run
  # Taint the resource to change the date
  lifecycle {
    ignore_changes = [end_date]
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}