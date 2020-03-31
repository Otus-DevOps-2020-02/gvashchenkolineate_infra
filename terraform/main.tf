//---------------------------------------------------------------------- terraform
terraform {
  # Версия terraform
  required_version = "~>0.12.0"
}
//---------------------------------------------------------------------- provider
provider "google" {
  # Версия провайдера
  version = "~>2.5.0"

  # ID проекта
  project = var.project

  region = var.region
}
//---------------------------------------------------------------------- project_metadata
resource "google_compute_project_metadata" "default" {
  project = var.project
  metadata = {
    ssh-keys = join("\n", [for user, key_path in var.user_public_key_path_map : "${user}:${file(key_path)}"])
  }
}
//---------------------------------------------------------------------- instance
resource "google_compute_instance" "app" {
  count = var.instance_count
  name         = "reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }
  tags = ["reddit-app"]
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "appuser"
    agent = false
    # путь до приватного ключа
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
//---------------------------------------------------------------------- firewall
resource "google_compute_firewall" "firewall_puma" {
  name = "default-allow-puma"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
