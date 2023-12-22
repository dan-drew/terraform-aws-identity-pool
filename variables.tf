variable "name" {
  type = string
}

variable "unauthenticated_policy" {
  type = object({ json = string })
}

variable "authenticated_policy" {
  type = object({ json = string })
}

variable "clients" {
  type = list(object({
    name      = string
    client_id = string
  }))
}
