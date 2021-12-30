resource "proxmox_vm_qemu" "pulp_server" {
  name        = "pulp_server"
  target_node = var.target_node
  iso         = var.target_iso
  onboot      = true
  oncreate      = true

  cores       = 1
  memory      = 512
  balloon     = 2048

  agent       = 1
  hotplug     = "network,disk,cpu"
  ipconfig0   = "ip=dhcp"
  
  sshkeys     = var.ssh_public_key
}