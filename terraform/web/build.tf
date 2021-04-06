module "project_build" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.2.2"

  name = "build"

  auto_create_network     = false
  billing_account         = data.terraform_remote_state.org.outputs.billing_account
  default_service_account = "deprivilege"
  folder_id               = data.terraform_remote_state.org.outputs.web_folder
  org_id                  = data.terraform_remote_state.org.outputs.org_id
  random_project_id       = "true"

  activate_apis = [
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com",
  ]
}

resource "google_cloudbuild_trigger" "terraform_pr" {
  provider = google-beta

  description = "Terraform Pull Request"
  filename    = "terraform/cloudbuild.yaml"
  name        = "terraform-pull-request"
  project     = module.project_build.project_id

  github {
    name  = var.repo_name
    owner = var.repo_owner

    pull_request {
      branch = ".*"
    }
  }

  included_files = ["docker-compose.yml", "terraform/**"]
}
