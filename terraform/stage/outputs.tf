output "app_external_ip" {
  value = module.app.app_external_ip
}
output "db_ip" {
  value = [
    "external: ${module.db.external_ip}",
    "internal: ${module.db.internal_ip}"
  ]
}

//output "load_balancer_ip" {
//  value = google_compute_global_forwarding_rule.reddit-app-fr.ip_address
//}
