//---------------------------------------------------------------------- instance app
resource "google_compute_instance" "app" {
  count = var.instance_count
  name         = "reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }
  tags = ["reddit-app"]
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "appuser"
    agent = false
    private_key = file(var.private_key_path)
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
//---------------------------------------------------------------------- IP Address
resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
//---------------------------------------------------------------------- firewall rule puma
resource "google_compute_firewall" "firewall_puma" {
  name = "default-allow-puma"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}
