terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

locals {
  proxmox_server_protocol = "https"
  proxmox_server_port     = 8006
}

provider "proxmox" {
  pm_user             = var.proxmox_user
  pm_api_token_id     = var.proxmox_token.id
  pm_api_token_secret = var.proxmox_token.secret
  pm_api_url          = "${local.proxmox_server_protocol}://${var.proxmox_host}:${local.proxmox_server_port}/api2/json"
}

resource "proxmox_lxc" "lxc" {
  target_node  = var.target_node
  hostname     = var.hostname
  ostemplate   = "${var.template_storage}:vztmpl/${var.source_template}"
  unprivileged = true
  onboot       = true
  password     = var.template_password
  start        = true

  ssh_public_keys = var.ssh_public_key

  rootfs {
    storage = var.root_storage
    size    = "${var.root_storage_size}G"
  }

  mountpoint {
    key     = "0"
    slot    = 0
    storage = var.data_storage
    mp      = var.data_storage_path
    size    = "${var.data_storage_size}G"
  }

  network {
    name   = var.network_name
    bridge = var.network_bridge
    ip     = var.network_ipv4
  }
}
