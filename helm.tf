module "helm" {
  # Source configuration
  source = "./modules/helm"
  # Required inputs
  # Google Cloud Provider configuration
  project = var.project
  region  = var.region
  zone    = var.zone
  # Implementation variables
  domain        = var.domain
  redirect_http = false
}
