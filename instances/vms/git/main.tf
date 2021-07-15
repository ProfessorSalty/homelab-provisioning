module "git" {
  source       = "github.com/ProfessorSalty/terraform-homelab"
  pm_api_url   = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  target_node  = var.proxmox_primary
  clone_source = var.ubuntu_docker_template
  name         = "git"
  vmid         = 516
  cores        = 4
  memory       = 4096

  disks = [{
    size    = "64G"
    storage = var.DUMMY_DRIVE
    },
    {
      size    = "50G"
      type    = "scsi"
      storage = "disk1"
  }]
}