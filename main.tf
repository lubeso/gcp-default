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
    roles   = ["owner"]
    subject = "${var.terraform_workspace_id}"
  }
  # Optional inputs
  # Nothing to do here...
}

