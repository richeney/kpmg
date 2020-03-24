provider "random" {
  version = "~> 2.2"
}

provider "azurerm" {
  version = "=2.1.0"
  features {}
}

provider "azuread" {
  version = "~> 0.8"
}

provider "azuread" {
  alias = "spcreator"

  version = "~> 0.8"

  tenant_id       = "ce508eb3-7354-4fb6-9101-03b4b81f8c54"
  subscription_id = "9a52c25a-b883-437e-80a6-ff4c2bccd44e"
  client_id       = "e1eea5ba-7b59-4e42-b4e2-79bf59d2660a"
  client_secret   = "u}A<uysPvF!Ha29m"
}