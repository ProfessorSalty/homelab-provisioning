module "torrent" {
  pm_api_url = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  source       = "github.com/ProfessorSalty/terraform-homelab"
  name         = "torrent"
  target_node  = var.proxmox_primary
  vmid         = 506
  clone_source = var.ubuntu_docker_template
  cores        = 2
  memory       = 4096

  networks = [{
    bridge = var.torrent_bridge
  }]
}
