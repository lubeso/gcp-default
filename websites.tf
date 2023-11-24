module "letterbox_website" {
  # Source configuration
  source = "./modules/website"
  # Required inputs
  # Google Cloud Provider configuration
  project = var.project
  region  = var.region
  zone    = var.zone
  # Implementation variables
  domain    = var.domain
  subdomain = "letterbox"
  # TODO: Redirect HTTP after SSL certificate finishes provisioning
  redirect_http = false
}
