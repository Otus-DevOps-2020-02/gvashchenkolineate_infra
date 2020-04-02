variable zone {
  description = "Zone"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}
variable instance_count {
  description = "Number of app instances to create"
  default = "1"
}
variable public_key_path {
  description = "Path to the public key used for ssh access to app instances"
}
variable private_key_path {
  description = "Path to the private key used for ssh access to app instances"
}
variable deploy_app {
  description = "Whether to deploy the app"
  default = true
}
