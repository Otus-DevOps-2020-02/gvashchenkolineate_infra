//---------------------------------------------------------------------- terraform / backend
terraform {
  required_version = "~>0.12.0"
  backend "gcs" {
    bucket  = "terraform-state-remote-backend-storage"
    prefix  = "prod/terraform/state"
  }
}
