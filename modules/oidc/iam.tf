module "service_account" {
  # Source configuration
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.2.2"
  # Required inputs
  project_id = var.project
  # Optional inputs
  prefix       = random_id.prefix.hex
  names        = [var.workload_identity_pool.id]
  display_name = var.workload_identity_pool.display_name
  project_roles = [
    for role in distinct(
      concat(var.service_account.roles, [
        "iam.serviceAccountUser",
        "iam.workloadIdentityUser"
      ])
    ) : "${var.project}=>roles/${role}"
  ]
}

resource "google_service_account_iam_member" "workload_identity_user" {
  # Required arguments
  service_account_id = module.service_account.service_account.id
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.default.name}/subject/${var.service_account.principal_subject}"
  role               = "roles/iam.workloadIdentityUser"
  # Optional arguments
  # Nothing to do here...
}
