output "db_ip" {
  value = [
    "external: ${google_compute_instance.db.network_interface[0].access_config[0].nat_ip}",
    "internal: ${google_compute_instance.db.network_interface[0].network_ip}"
  ]
}
