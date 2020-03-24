data "azurerm_client_config" "current" {
}

resource "azuread_application" "spcreator" {
  name = "service_principal_creator"

  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
      id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
      type = "Scope"
    }

    resource_access {
      id   = "1cda74f2-2616-4834-b122-5cb1b07f8a59"
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "spcreator" {
  application_id = azuread_application.spcreator.application_id
}

resource "random_string" "spcreator_password" {
  length  = 16
  special = true
  keepers = {
    service_principal = azuread_service_principal.spcreator.id
  }
}

resource "azuread_service_principal_password" "spcreator_password" {
  service_principal_id = azuread_service_principal.spcreator.id
  value                = random_string.spcreator_password.result
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