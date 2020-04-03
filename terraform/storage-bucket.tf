provider "google" {
  version = "~>2.5.0"
  project = var.project
  region = var.region
}
//---------------------------------------------------------------------- storage bucket for terraform state remote backend
module "storage-bucket" {
  source = "SweetOps/storage-bucket/google"
  version = "0.3.0"

  name = "terraform-state-remote-backend-storage"

  // Must set location. Otherwise, get an error:
  //    Error: googleapi: Error 400: The combination of locationConstraint and storageClass you provided is not supported for your project, invalid
  location = var.region
}

output storage-bucket_url {
  value = module.storage-bucket.url
}
