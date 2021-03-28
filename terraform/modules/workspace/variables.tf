variable "billing_account" {
  type        = string
  description = "Billing account ID, for the default billing account."
}

variable "name" {
  type        = string
  description = "Workspace name. Should be unique in the organization."
}

variable "org_id" {
  type        = string
  description = "Organization ID, where resources are created."
}