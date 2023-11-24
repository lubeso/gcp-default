resource "google_iam_workload_identity_pool" "default" {
  # Required arguments
  workload_identity_pool_id = random_id.default.hex
  # Optional argumnets
  display_name = var.workload_identity_pool.display_name
  disabled     = var.workload_identity_pool.disabled
}

resource "google_iam_workload_identity_pool_provider" "default" {
  # Required arguments
  workload_identity_pool_provider_id = "oidc"
  workload_identity_pool_id          = google_iam_workload_identity_pool.default.workload_identity_pool_id
  # Optional arguments
  display_name        = "OpenID Connect (OIDC)"
  disabled            = var.workload_identity_pool_provider.disabled
  attribute_condition = var.workload_identity_pool_provider.attribute_condition
  attribute_mapping   = var.workload_identity_pool_provider.attribute_mapping
  oidc {
    issuer_uri = var.workload_identity_pool_provider.oidc.issuer_uri
  }
}
