module "mediaserver" {
  source       = "github.com/ProfessorSalty/terraform-homelab"
  pm_api_url   = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  pm_user     = ''
  target_node  = var.proxmox_primary
  clone_source = var.ubuntu_docker_template
  name         = "mediaserver"
  vmid         = 505
  cores        = 10
  memory       = 32768

  networks = [{
    bridge = var.streaming_bridge
  }]

  disks = [{
    size    = "450G"
    storage = var.transcode_drive
    ssd     = 1
  }]
}

output "machine" {
  
}