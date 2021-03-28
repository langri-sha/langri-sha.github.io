locals {
  org_admin_members = [
    for user in split(",", var.org_admin_members)
    : "user:${user}@${data.google_organization.org.domain}"
  ]
  org_billing_admin_members = [
    for user in split(",", var.org_billing_admin_members)
    : "user:${user}@${data.google_organization.org.domain}"
  ]
}

data "google_organization" "org" {
  domain = var.org_domain
}

resource "google_cloud_identity_group" "org_admins" {
  display_name = "Org Admins"
  description  = "Users responsible for managing the organization"

  parent = data.google_organization.org.name

  group_key {
      id = "admins@${data.google_organization.org.domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

resource "google_organization_iam_binding" "org_admin_folder_creator" {
  org_id  = data.google_organization.org.org_id
  role    = "roles/resourcemanager.folderCreator"
  members = local.org_admin_members
}

resource "google_organization_iam_binding" "org_admin_project_creator" {
  org_id  = data.google_organization.org.org_id
  role    = "roles/resourcemanager.projectCreator"
  members = local.org_admin_members
}

resource "google_organization_iam_binding" "org_billing_admin_billing_creator" {
  org_id  = data.google_organization.org.org_id
  role    = "roles/billing.creator"
  members = local.org_billing_admin_members
}
