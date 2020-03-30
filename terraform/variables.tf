variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}
variable disk_image {
  description = "Disk image"
}
variable user_public_key_path_map {
  # Описание переменной
  description = "Map of user - public key path for Project ssh access"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}
