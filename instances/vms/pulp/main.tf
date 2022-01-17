resource "proxmox_vm_qemu" "pulp_server" {
  // does running this change any of the template's settings?
  name        = "pulp_server"
  target_node = var.target_node
  clone       = var.clone_source
  vmid        = 500
  onboot      = true
  oncreate    = true
  full_clone = false

  cores   = 1
  memory  = 512
  balloon = 2048

  agent     = 1
  ipconfig0 = "ip=dhcp"
  
  network {
    model = "virtio"
    bridge = var.network_bridge
  }
  
  disk {
    type = "scsi"
    storage = var.data_storage_path
    size = "32G"
  }
}