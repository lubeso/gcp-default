resource "random_id" "charts" {
  # Required arguments
  byte_length = 2
  # Optional arguments
  prefix = "helm-charts-"
}

resource "google_storage_bucket" "charts" {
  # Required arguments
  name     = random_id.charts.hex
  location = upper(var.region)
  # Optional arguments
  force_destroy = true
  project       = var.project
  storage_class = "STANDARD"
  website { main_page_suffix = "index.yaml" }
}

module "charts_bucket_iam" {
  # Source configuration
  source  = "terraform-google-modules/iam/google//modules/storage_buckets_iam"
  version = "~> 7.7.1"
  # Required inputs
  # Nothing to do here...
  # Optional inputs
  storage_buckets = [google_storage_bucket.charts.name]
  bindings        = { "roles/storage.objectViewer" = ["allUsers"] }
}

resource "google_compute_backend_bucket" "charts" {
  # Required arguments
  bucket_name = google_storage_bucket.charts.name
  name        = "helm-charts"
  # Optional arguments
  enable_cdn = true
}
