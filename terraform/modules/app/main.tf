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
}
//---------------------------------------------------------------------- conditionally create systemd unit file
resource "local_file" "systemd_unit_file" {
  count = var.deploy_app ? 1 : 0

  content = templatefile("${path.module}/files/puma.service.tpl", {
    database_url = var.database_url
  })

  filename = "${path.module}/files/puma.service"
}
//---------------------------------------------------------------------- conditionally use deploy provisioners
resource "null_resource" "cluster" {
  count = var.deploy_app ? 1 : 0

  connection {
    type  = "ssh"
    host  = google_compute_instance.app[count.index].network_interface[0].access_config[0].nat_ip
    user  = "appuser"
    agent = false
    private_key = file(var.private_key_path)
  }
  provisioner "file" {
    source      = "${path.module}/files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}
//---------------------------------------------------------------------- IP Address
resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
//---------------------------------------------------------------------- firewall rule puma
resource "google_compute_firewall" "firewall_puma" {
  count = 0 # don't expose puma port!
  name = "default-allow-puma"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}
//---------------------------------------------------------------------- firewall rule http
resource "google_compute_firewall" "firewall_http" {
  name = "reddit-app-allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}
