terraform {
  experiments = [module_variable_optional_attrs]
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_password     = var.pm_user_pass
  pm_api_url      = var.pm_api_url
}

resource "proxmox_lxc" "lxc" {
  target_node  = var.target_node
  hostname     = var.hostname
#  ostemplate   = "local:vztmpl/ubuntu-21.04-standard_21.04-1_amd64.tar.gz"
  ostemplate   = "${var.template_storage}:${var.source_template}"
  unprivileged = true
  onboot = true
  password = var.template_password

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
