module "motioneye" {
  pm_api_url   = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  source       = "github.com/ProfessorSalty/terraform-homelab"
  name         = "motioneye"
  target_node  = var.proxmox_secondary
  vmid         = 514
  clone_source = var.ubuntu_docker_template
  cores        = 4
  memory       = 4096
}
