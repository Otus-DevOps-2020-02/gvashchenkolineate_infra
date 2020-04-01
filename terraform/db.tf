//---------------------------------------------------------------------- instance db
resource "google_compute_instance" "db" {
  name = "reddit-db"
  machine_type = "g1-small"
  zone = var.zone
  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }
  tags = ["reddit-db"]
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}
//---------------------------------------------------------------------- firewall rule puma
resource "google_compute_firewall" "firewall_mongo" {
  name = "default-allow-mongo"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["27017"]
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
