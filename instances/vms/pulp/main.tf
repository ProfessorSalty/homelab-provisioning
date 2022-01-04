resource "proxmox_vm_qemu" "pulp_server" {
  // does running this change any of the template's settings?
  name        = "pulp_server"
  target_node = var.target_node
  clone       = var.clone_source
  onboot      = true
  oncreate    = true

  cores   = 1
  memory  = 512
  balloon = 2048

  agent     = 1
  ipconfig0 = "ip=dhcp"

}