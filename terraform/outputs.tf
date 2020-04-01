output "app_external_ip" {
  value = google_compute_instance.app[*].network_interface[0].access_config[0].nat_ip
}

//output "load_balancer_ip" {
//  value = google_compute_global_forwarding_rule.reddit-app-fr.ip_address
//}
