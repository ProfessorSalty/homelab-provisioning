variable "boot_command" {
  type    = string
  default = ""
}

variable "cloud_init" {
  type    = string
  default = "false"
}

variable "iso_file" {
  type    = string
  default = ""
}

variable "iso_storage" {
  type    = string
  default = ""
}

variable "main_drive_size" {
  type    = string
  default = "32G"
}

variable "network_bridge" {
  type    = string
  default = "vmbr1"
}

variable "os" {
  type    = string
  default = "l26"
}

variable "proxmox_node" {
  type    = string
  default = "vm1"
}

variable "proxmox_password" {
  type    = string
  default = ""
}

variable "proxmox_template_description" {
  type    = string
  default = ""
}

variable "proxmox_username" {
  type    = string
  default = ""
}

variable "proxmox_vm_id" {
  type    = string
  default = ""
}

variable "public_key_file" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "storage_pool" {
  type    = string
  default = "vms"
}

variable "template_name" {
  type    = string
  default = ""
}

variable "template_username" {
  type    = string
  default = ""
}
