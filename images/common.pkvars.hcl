local "cloud_init" {
  type    = string
  default = "true"
}

local "public_key_file" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

local "storage_pool" {
  type    = string
  default = "vms"
}

local "main_drive_size" {
  type    = string
  default = "32G"
}

local "network_bridge" {
  type    = string
  default = "vmbr1"
}

local "os" {
  type    = string
  default = "l26"
}

local "http_directory" {
  type    = string
  default = "true"
}

local "proxmox_server_protocol" {
  type = string
  default = "https"
}

local "proxmox_server_port" {
  type = string
  default = "8006"
}
