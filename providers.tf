provider "azurerm" {
  version = "=2.1.0"
  features {}
}

provider "azuread" {
  version = "~> 0.8"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}
