//---------------------------------------------------------------------- provider
provider "google" {
  version = "~>2.5.0"
  project = var.project
  region  = var.region
}
//---------------------------------------------------------------------- project_metadata
resource "google_compute_project_metadata" "default" {
  project = var.project
  metadata = {
    ssh-keys = join("\n", [for user, key_path in var.user_public_key_path_map : "${user}:${file(key_path)}"])
  }
}
//---------------------------------------------------------------------- app
module "app" {
  source           = "../modules/app"
  zone             = var.zone
  app_disk_image   = var.app_disk_image
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  deploy_app = true
}
//---------------------------------------------------------------------- db
module "db" {
  source          = "../modules/db"
  zone            = var.zone
  db_disk_image   = var.db_disk_image
  public_key_path = var.public_key_path
}
//---------------------------------------------------------------------- vpc
module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
}
