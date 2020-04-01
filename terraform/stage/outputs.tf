output "app_external_ip" {
  value = module.app.app_external_ip
}
output "db_ip" {
  value = module.db.db_ip
}

//output "load_balancer_ip" {
//  value = google_compute_global_forwarding_rule.reddit-app-fr.ip_address
//}
