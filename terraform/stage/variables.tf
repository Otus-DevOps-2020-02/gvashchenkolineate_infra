variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable disk_image {
  description = "Disk image"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable instance_count {
  description = "Number of instances to create"
  default     = "1"
}

variable user_public_key_path_map {
  description = "Map of user - public key path for Project ssh access"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable ssh_source_range {
  description = "IP range allowed to connect to instances via ssh"
  default     = ["0.0.0.0/0"]
}
