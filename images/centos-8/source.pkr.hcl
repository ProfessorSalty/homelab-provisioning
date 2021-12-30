source "proxmox" "vm" {
  boot_command            = var.boot_command
  boot_wait               = "6s"
  cloud_init              = var.cloud_init
  cloud_init_storage_pool = var.storage_pool
  cores                   = 1
  http_directory           = path.root/var.http_dir
  iso_file                 = "${var.iso_storage}:iso/${var.iso_file}"
  memory                   = 2048
  node                 = var.proxmox_node
  os                   = var.os
  password             = var.proxmox_password
  proxmox_url          = "${var.proxmox_server_protocol}://${var.proxmox_host}:${var.proxmox_server_port}/api2/json"
  qemu_agent           = true
  scsi_controller      = "virtio-scsi"
  ssh_password         = var.user_password
  ssh_timeout          = "90m"
  ssh_username         = var.template_username
  template_description = var.proxmox_template_description
  template_name        = var.template_name
  unmount_iso          = true
  username             = var.proxmox_username
  vm_id                = var.proxmox_vm_id

  disks {
    disk_size         = var.main_drive_size
    format            = "raw"
    storage_pool      = var.storage_pool
    storage_pool_type = "lvm-thin"
    type              = "scsi"
  }

  network_adapters {
    bridge = var.network_bridge
    model  = "virtio"
  }
}
