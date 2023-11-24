resource "random_id" "default" {
  # Required arguments
  byte_length = 2
  # Optional arguments
  prefix = "${var.workload_identity_pool.id}-"
}
