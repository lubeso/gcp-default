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
  managed { domains = ["${var.subdomain}.${var.domain}"] }
}

resource "google_compute_url_map" "default" {
  # Required arguments
  name = var.subdomain
  # Optional arguments
  default_service = google_compute_backend_bucket.public.id
  host_rule {
    hosts        = ["${var.subdomain}.${var.domain}"]
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
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.name]
  # Optional arguments
  # Nothing to do here...
}

resource "google_compute_url_map" "http_redirect" {
  # Meta-arguments
  count = var.redirect_http ? 1 : 0
  # Required arguments
  name = "${var.subdomain}-http-redirect"
  # Optional arguments
  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

resource "google_compute_global_forwarding_rule" "http" {
  # Required arguments
  name   = "${var.subdomain}-http"
  target = google_compute_target_http_proxy.default.id
  # Optional arguments
  ip_address            = google_compute_global_address.default.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
}

resource "google_compute_target_http_proxy" "default" {
  # Required arguments
  name = var.subdomain
  url_map = var.redirect_http ? (
    google_compute_url_map.http_redirect[0].self_link
  ) : google_compute_url_map.default.self_link
  # Optional arguments
  # Nothing to do here...
}
