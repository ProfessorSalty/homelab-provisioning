module "startpage" {
  source = "../template"
  pm_api_url   = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  name         = "startpage"
  target_node  = var.proxmox_secondary
  vmid         = 509
  clone_source = var.ubuntu_docker_template
  cores        = 4
  memory       = 4096
}
