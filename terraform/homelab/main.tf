locals {
  proxmox_primary         = "vm1"
  proxmox_secondary       = "vm2"
  default_bridge          = "vmbr1"
  streaming_bridge        = "vmbr2"
  usenet_bridge           = "vmbr3"
  torrent_bridge          = "vmbr4"
  ubuntu_docker_template  = "ubuntu-20.04-docker-template"
  centos_freeipa_template = "centos-8-template"
  os_type_ubuntu          = "ubuntu"
  os_type_centos          = "centos"
  transcode_drive         = "transcodes"
  storage_drive           = "bigdrive"
  download_drive          = "downloads"
  fast_drive              = "db"
  # This is necessary because the Telmate/proxmox plugin does not properly handle hard drives
  DUMMY_DRIVE = "DUMMY_DRIVE"
}

module "freeipa-server" {
  pm_api_url   = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  source       = "github.com/ProfessorSalty/terraform-homelab"
  name         = "freeipa"
  clone_source = local.centos_freeipa_template
  target_node  = local.proxmox_primary
  os_type      = local.os_type_centos
  vmid         = 400

  disks = [{
    size     = "128G"
    storage  = local.DUMMY_DRIVE
    iothread = true
  }]
}

module "mediaserver" {
  pm_api_url   = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  source       = "github.com/ProfessorSalty/terraform-homelab"
  target_node  = local.proxmox_primary
  clone_source = local.ubuntu_docker_template
  os_type      = local.os_type_ubuntu
  name         = "mediaserver"
  vmid         = 505
  cores        = 10
  memory       = 32768

  networks = [{
    bridge = local.streaming_bridge
  }]

  disks = [{
    size    = "128G"
    storage = local.DUMMY_DRIVE
    }, {
    size    = "450G"
    storage = local.transcode_drive
    ssd     = 1
  }]
}

# // *arr, nzbget, jackett
module "downloader" {
  pm_api_url   = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  source       = "github.com/ProfessorSalty/terraform-homelab"
  name         = "downloader"
  target_node  = local.proxmox_primary
  vmid         = 506
  clone_source = local.ubuntu_docker_template
  os_type      = local.os_type_ubuntu
  cores        = 2
  memory       = 16384

  networks = [{
    model  = "virtio"
    bridge = local.usenet_bridge
  }]

  disks = [{
    size    = "128G"
    storage = local.DUMMY_DRIVE
    }, {
    size    = "1500G"
    storage = local.storage_drive
    }, {
    size    = "400G"
    storage = local.download_drive
    ssd     = 1
  }]
}

# module "torrent" {
# pm_api_url = var.pm_api_url
# pm_user_pass = var.pm_user_pass
#   source       = "github.com/ProfessorSalty/terraform-homelab"
#   name         = "torrent"
#   target_node  = local.proxmox_primary
#   vmid         = 506
#   clone_source = local.ubuntu_docker_template
#   cores        = 2
#   memory       = 4096

#   networks = [{
#     bridge = local.torrent_bridge
#   }]
# }

# // nextcloud, papermerge, filestash
# module "office" {
# pm_api_url = var.pm_api_url
# pm_user_pass = var.pm_user_pass
#   source       = "github.com/ProfessorSalty/terraform-homelab"
#   name         = "office"
#   target_node  = local.proxmox_secondary
#   vmid         = 508
#   clone_source = local.ubuntu_docker_template
#   cores        = 2
#   memory       = 4096
# }

# module "bitwarden" {
# pm_api_url = var.pm_api_url
# pm_user_pass = var.pm_user_pass
#   name         = "bitwarden"
#   target_node  = local.proxmox_secondary
#   vmid         = 509
#   clone_source = local.ubuntu_docker_template
#   cores        = 4
#   memory       = 4096
# }

# module "friendica" {
# pm_api_url = var.pm_api_url
# pm_user_pass = var.pm_user_pass
#   source       = "github.com/ProfessorSalty/terraform-homelab"
#   name         = "friendica"
#   target_node  = local.proxmox_secondary
#   vmid         = 510
#   clone_source = local.ubuntu_docker_template
#   cores        = 4
#   memory       = 4096
# }

# module "mailserver" {
# pm_api_url = var.pm_api_url
# pm_user_pass = var.pm_user_pass
#   source       = "github.com/ProfessorSalty/terraform-homelab"
#   name         = "mailserver"
#   target_node  = local.proxmox_secondary
#   vmid         = 513
#   clone_source = local.ubuntu_docker_template
#   cores        = 4
#   memory       = 4096
# }

# module "git" {
# pm_api_url = var.pm_api_url
# pm_user_pass = var.pm_user_pass
#   source       = "github.com/ProfessorSalty/terraform-homelab"
#   name         = "git"
#   target_node  = local.proxmox_primary
#   vmid         = 516
#   clone_source = local.ubuntu_docker_template
#   cores        = 4
#   memory       = 4096

#   disks = [{
#     size    = "64G"
#     storage = local.DUMMY_DRIVE
#     },
#     {
#       size    = "50G"
#       type    = "scsi"
#       storage = "disk1"
#   }]
# }

# // element, jitsi
# module "chat" {
# pm_api_url = var.pm_api_url
# pm_user_pass = var.pm_user_pass
#   source       = "github.com/ProfessorSalty/terraform-homelab"
#   name         = "chat"
#   target_node  = local.proxmox_secondary
#   vmid         = 515
#   clone_source = local.ubuntu_docker_template
#   cores        = 4
#   memory       = 4096
# }

# // home assistant, node RED, thingspeak
# module "automation" {
# pm_api_url = var.pm_api_url
# pm_user_pass = var.pm_user_pass
#   source       = "github.com/ProfessorSalty/terraform-homelab"
#   name         = "automation"
#   target_node  = local.proxmox_secondary
#   vmid         = 514
#   clone_source = local.ubuntu_docker_template
#   cores        = 4
#   memory       = 4096
# }
