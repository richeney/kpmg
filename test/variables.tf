variable "service_principal_name" {
  type    = string
  default = "my-service-principal"
}

variable "subscriptions" {
  type    = list(string)
  default = []
}

variable "owners_group" {
  type        = string
  default     = "Service Principal Owners"
  description = "Cosmetic name for the AAD security group to include as owners."
}
