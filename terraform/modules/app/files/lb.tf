//---------------------------------------------------------------------- unmanaged instance group
resource "google_compute_instance_group" "reddit-app-umig" {
  name        = "reddit-app-umig"
  description = "Monolith Reddit app unmanaged instance group"
  zone        = var.zone

  instances = google_compute_instance.app.*.self_link

  named_port {
    name = "puma"
    port = "9292"
  }
}
//---------------------------------------------------------------------- health check
resource "google_compute_health_check" "reddit-app-hc" {
  name        = "reddit-app-hc"
  description = "Monolith Reddit app health check"

  http_health_check {
    port = 9292
  }
}
//---------------------------------------------------------------------- backend service
resource "google_compute_backend_service" "reddit-app-bes" {
  name          = "reddit-app-bes"
  description   = "Monolith Reddit app backend service"
  port_name     = "puma"
  protocol      = "HTTP"
  health_checks = [google_compute_health_check.reddit-app-hc.self_link]
  backend {
    group = google_compute_instance_group.reddit-app-umig.self_link
  }
}

//---------------------------------------------------------------------- target proxy
resource "google_compute_target_http_proxy" "reddit-app-tp" {
  name        = "reddit-app-tp"
  description = "Monolith Reddit app target proxy"
  url_map     = google_compute_url_map.reddit-app-um.self_link
}
//---------------------------------------------------------------------- URL map (aka load balancers)
resource "google_compute_url_map" "reddit-app-um" {
  name            = "reddit-app-lb"
  description     = "Monolith Reddit app load balancer (URL map)"
  default_service = google_compute_backend_service.reddit-app-bes.self_link
}
//---------------------------------------------------------------------- forwarding rule
resource "google_compute_global_forwarding_rule" "reddit-app-fr" {
  name        = "reddit-app-fr"
  description = "Monolith Reddit app global forwarding rule"
  target      = google_compute_target_http_proxy.reddit-app-tp.self_link
  port_range  = "80-80"
}
