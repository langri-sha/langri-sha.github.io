locals {
  admins = [
    for user in split(",", var.admin_members)
    : "user:${user}@${data.google_organization.org.domain}"
  ]
  billing_admins = [
    for user in split(",", var.billing_admin_members)
    : "user:${user}@${data.google_organization.org.domain}"
  ]
}

data "google_organization" "org" {
  domain = var.domain
}

module "project_org" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.2.2"

  name = "organization"

  auto_create_network     = false
  billing_account         = data.google_billing_account.default.billing_account
  default_service_account = "deprivilege"
  org_id                  = data.google_organization.org.org_id
  random_project_id       = "true"

  activate_apis = var.activate_apis
}

data "google_billing_account" "default" {
  billing_account = var.billing_account
  open = true

  depends_on = [
    google_organization_iam_binding.org_billing_admin_billing_creator
  ]
}

resource "google_organization_iam_binding" "org_admin_service_usage_viewer" {
  org_id  = data.google_organization.org.org_id
  role    = "roles/serviceusage.serviceUsageViewer"
  members = local.admins
}

resource "google_organization_iam_binding" "org_billing_admin_billing_creator" {
  org_id  = data.google_organization.org.org_id
  role    = "roles/billing.creator"
  members = local.billing_admins
}
