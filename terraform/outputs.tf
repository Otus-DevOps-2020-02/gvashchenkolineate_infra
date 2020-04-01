output "app_external_ip" {
  value = google_compute_instance.app[*].network_interface[0].access_config[0].nat_ip
}
output "db_ip" {
  value = [
    "external: ${google_compute_instance.db.network_interface[0].access_config[0].nat_ip}",
    "internal: ${google_compute_instance.db.network_interface[0].network_ip}"
  ]
}

//output "load_balancer_ip" {
//  value = google_compute_global_forwarding_rule.reddit-app-fr.ip_address
//}
