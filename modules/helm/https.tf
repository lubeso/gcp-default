resource "google_compute_global_address" "helm" {
  # Required arguments
  name = "helm"
  # Optional arguments
  # Nothing to do here...
}

resource "google_compute_managed_ssl_certificate" "helm" {
  # Provider configuration
  provider = google-beta
  # Required arguments
  name = "helm"
  # Optional arguments
  managed { domains = ["helm.${var.domain}"] }
}

resource "google_compute_url_map" "helm" {
  # Required arguments
  name = "helm"
  # Optional arguments
  default_service = google_compute_backend_bucket.charts.id
  host_rule {
    hosts        = ["helm.${var.domain}"]
    path_matcher = "helm"
  }
  path_matcher {
    name            = "helm"
    default_service = google_compute_backend_bucket.charts.id
    # Charts
    path_rule {
      paths   = ["/charts/*"]
      service = google_compute_backend_bucket.charts.id
    }
  }
}

resource "google_compute_global_forwarding_rule" "helm_https" {
  # Required arguments
  name   = "helm-https"
  target = google_compute_target_https_proxy.helm.id
  # Optional arguments
  ip_address            = google_compute_global_address.helm.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
}

resource "google_compute_target_https_proxy" "helm" {
  # Provider configuration
  provider = google-beta
  # Required arguments
  name             = "helm"
  url_map          = google_compute_url_map.helm.id
  ssl_certificates = [google_compute_managed_ssl_certificate.helm.name]
  # Optional arguments
  # Nothing to do here...
}

resource "google_compute_url_map" "helm_http_redirect" {
  # Meta-arguments
  count = var.redirect_http ? 1 : 0
  # Required arguments
  name = "helm-http-redirect"
  # Optional arguments
  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

resource "google_compute_global_forwarding_rule" "helm_http" {
  # Required arguments
  name   = "helm-http"
  target = google_compute_target_http_proxy.helm.id
  # Optional arguments
  ip_address            = google_compute_global_address.helm.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
}

resource "google_compute_target_http_proxy" "helm" {
  # Required arguments
  name = "helm"
  url_map = var.redirect_http ? (
    google_compute_url_map.helm_http_redirect[0].self_link
  ) : google_compute_url_map.helm.self_link
  # Optional arguments
  # Nothing to do here...
}
