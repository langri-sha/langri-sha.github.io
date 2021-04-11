terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "langri-sha"

    workspaces {
      name = "org"
    }
  }
}

module "org" {
  source = "../modules/org"

  admin_members         = var.org_admin_members
  billing_admin_members = var.org_billing_admin_members
}

module "billing" {
  source = "../modules/billing"

  billing_account = var.billing_account

  depends_on = [
    module.org
  ]
}

module "web" {
  source = "../modules/workspace"

  name = "web"

  billing_account = module.billing.billing_account
  org_admins      = module.org.admins
  org_id          = module.org.org_id
}
