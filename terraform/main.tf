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
