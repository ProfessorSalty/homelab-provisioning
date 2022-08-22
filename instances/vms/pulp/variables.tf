variable "proxmox_token" {
  sensitive = true
  type      = object({
    id = string
    secret = string
  })
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_user" {
  type = string
  validation {
    condition = can(regex("@(pam|pve)$", var.proxmox_user))
    error_message = "Please enter the full username with the authentication domain (@pve, @pam, etc.)."
  }
}

variable "data_storage_path" {
  type = string
  description = "The name of the storage pool on the Proxmox node that will host the disk"
}

variable "target_node" {
  type = string
  description = "The Proxmox node that will host the VM"
}

variable "clone_source" {
  type = string
  description = "Which template to use when building the VM"
}

variable "network_bridge" {
  type = string
  default = "vmbr1"
  description = "Which network bridge will the VM use"
}

