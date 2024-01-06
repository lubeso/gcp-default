module "terraform_cloud_oidc" {
  # Source configuration
  source = "./modules/oidc"
  # Required inputs
  # Google Cloud provider configuration
  project = var.project
  region  = var.region
  zone    = var.zone
  # Implementation variables
  workload_identity_pool = {
    id           = "terraform-cloud"
    display_name = "Terraform Cloud"
  }
  workload_identity_pool_provider = {
    attribute_condition = "(assertion.terraform_organization_id == '${var.terraform_organization_id}')"
    attribute_mapping = {
      "google.subject" = "assertion.terraform_workspace_id"
    }
    oidc = { issuer_uri = "https://app.terraform.io" }
  }
  service_account = {
    account_id        = "terraform-cloud"
    display_name      = "Terraform Cloud"
    roles             = ["owner"]
    principal_subject = "${var.terraform_workspace_id}"
  }
  # Optional inputs
  # Nothing to do here...
}

module "github_actions_oidc" {
  # Source configuration
  source = "./modules/oidc"
  # Required inputs
  # Google Cloud provider configuration
  project = var.project
  region  = var.region
  zone    = var.zone
  # Implementation variables
  workload_identity_pool = {
    id           = "github-actions"
    display_name = "GitHub Actions"
  }
  workload_identity_pool_provider = {
    attribute_condition = "(assertion.ref == 'refs/heads/main' || assertion.ref.startsWith('refs/tags/'))"
    attribute_mapping   = { "google.subject" = "assertion.repository_owner_id" }
    oidc                = { issuer_uri = "https://token.actions.githubusercontent.com" }
  }
  service_account = {
    account_id   = "github-actions"
    display_name = "GitHub Actions"
    roles = [
      "artifactregistry.admin",
      "cloudbuild.builds.builder",
      "run.admin",
      "storage.admin",
    ],
    principal_subject = var.github_owner_id
  }
  # Optional inputs
  # Nothing to do here...
}
