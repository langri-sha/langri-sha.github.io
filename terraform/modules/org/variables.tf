variable "admin_members" {
  type        = string
  description = "Comma-separated list of users who are assigned to administer the organization."
}

variable "billing_admin_members" {
  type        = string
  description = "Comma-separated list of users who are assigned to administer billing accounts in the organization."
}

variable "domain" {
  description = "Organization domain, for which resources are created."
  type        = string
}
