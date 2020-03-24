variable "service_principal_name" {
  type    = string
  default = "my-service-principal"
}

variable "subscriptions" {
  type    = list(string)
  default = []
}
