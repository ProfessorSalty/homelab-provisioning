module "downloader" {
  source          = "../template"
  pm_api_url      = var.pm_api_url
  pm_user_pass    = var.pm_user_pass
  name            = "downloader"
  target_node     = var.proxmox_primary
  vmid            = 506
  clone_source    = var.ubuntu_docker_template
  os_type         = var.os_type_ubuntu
  cores           = 2
  memory          = 16384

  networks = [{
    model  = "virtio"
    bridge = var.usenet_bridge
  }]

  disks = [{
    size    = "128G"
    storage = var.DUMMY_DRIVE
    }, {
    size    = "1500G"
    storage = var.storage_drive
    }, {
    size    = "400G"
    storage = var.download_drive
    ssd     = 1
  }]
}
