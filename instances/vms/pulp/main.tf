terraform {
  experiments = [module_variable_optional_attrs]
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

locals {
  proxmox_server_protocol = "https"
  proxmox_server_port     = 8006
  proxmox_username_token  = "${var.proxmox_user}!${var.proxmox_token.id}"
}

provider "proxmox" {
  pm_api_token_id     = local.proxmox_username_token
  pm_api_token_secret = var.proxmox_token.secret
  pm_api_url          = "${local.proxmox_server_protocol}://${var.proxmox_host}:${local.proxmox_server_port}/api2/json"
}

resource "proxmox_vm_qemu" "pulp_server" {
  // does running this change any of the template's settings?
  name        = "pulp_server"
  target_node = var.target_node
  clone       = var.clone_source
  vmid        = 500
  onboot      = true
  oncreate    = true
  full_clone  = false

  cores   = 1
  memory  = 512
  balloon = 2048

  agent     = 1
  ipconfig0 = "ip=dhcp"

  network {
    model  = "virtio"
    bridge = var.network_bridge
  }

  disk {
    type    = "scsi"
    storage = var.data_storage_path
    size    = "32G"
  }
}