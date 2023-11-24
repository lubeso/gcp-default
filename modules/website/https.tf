locals {
  full_domain = (
    var.subdomain != "www"
  ) ? "${var.subdomain}.${var.domain}" : var.domain
}

resource "google_compute_global_address" "default" {
  # Required arguments
  name = var.subdomain
  # Optional arguments
  # Nothing to do here...
}

resource "google_compute_managed_ssl_certificate" "default" {
  # Provider configuration
  provider = google-beta
  # Required arguments
  name = var.subdomain
  # Optional arguments
  managed { domains = [local.full_domain] }
}

resource "google_compute_url_map" "https" {
  # Required arguments
  name = "${var.subdomain}-https"
  # Optional arguments
  default_service = google_compute_backend_bucket.public.id
  host_rule {
    hosts        = [local.full_domain]
    path_matcher = "default"
  }
  path_matcher {
    name            = "default"
    default_service = google_compute_backend_bucket.public.id
    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_bucket.public.id
    }
  }
}

resource "google_compute_global_forwarding_rule" "https" {
  # Required arguments
  name   = "${var.subdomain}-https"
  target = google_compute_target_https_proxy.default.id
  # Optional arguments
  ip_address            = google_compute_global_address.default.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
}

resource "google_compute_target_https_proxy" "default" {
  # Provider configuration
  provider = google-beta
  # Required arguments
  name             = var.subdomain
  url_map          = google_compute_url_map.https.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.name]
  # Optional arguments
  # Nothing to do here...
}

resource "google_compute_url_map" "http_redirect" {
  # Required arguments
  name = "${var.subdomain}-http-redirect"
  # Optional arguments
  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

resource "google_compute_global_forwarding_rule" "http_redirect" {
  # Required arguments
  name   = "${var.subdomain}-http-redirect"
  target = google_compute_target_http_proxy.default.id
  # Optional arguments
  ip_address            = google_compute_global_address.default.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
}

resource "google_compute_target_http_proxy" "default" {
  # Required arguments
  name    = var.subdomain
  url_map = google_compute_url_map.http_redirect.self_link
  # Optional arguments
  # Nothing to do here...
}
