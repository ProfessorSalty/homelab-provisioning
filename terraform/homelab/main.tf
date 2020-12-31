locals {
  proxmox_primary         = "vm1"
  proxmox_secondary       = "vm2"
  default_bridge          = "vmbr0"
  streaming_bridge        = "vmbr1"
  downloader_bridge       = "vmbr2"
  torrent_bridge          = "vmbr3"
  ubuntu_docker_template  = "ubuntu-20.04-docker-template"
  centos_freeipa_template = "centos-8-template"
  os_type_ubuntu          = "ubuntu"
  os_type_centos          = "centos"
  transcode_drive         = "transcode"
  storage_drive           = "storage"
  download_drive          = "downloads"
  fast_drive              = "db"
  # This is necessary because the Telmate/proxmox plugin does not properly handle hard drives
  DUMMY_DRIVE = "DUMMY_DRIVE"
}

# module "freeipa-server" {
#   source       = "./modules/homelab"
#   name         = "freeipa"
#   clone_source = local.centos_freeipa_template
#   target_node  = local.proxmox_primary
#   os_type      = local.os_type_centos
#   vmid         = 400
# }

module "jellyfin" {
  source       = "./modules/homelab"
  target_node  = local.proxmox_primary
  clone_source = local.ubuntu_docker_template
  os_type      = local.os_type_ubuntu
  name         = "jellyfin-test"
  vmid         = 505
  cores        = 10
  memory       = 32768

  networks = [{
    bridge = local.streaming_bridge
  }]

  disks = [{
    size    = "64G"
    storage = local.DUMMY_DRIVE
    }, {
    size    = "450G"
    storage = local.transcode_drive
    ssd     = true
  }]
}

# module "ampache" {
#   source = "./modules/homelab"
#   name = "ampache"
#   target_node = var.proxmox_primary
#   vmid = 512
#   clone_source = local.ubuntu_docker_template
#   cores = 4
#   memory = 4096

#   networks = [{
#     network_bridge = local.streaming_bridge
#   }]
# }

# // *arr, nzbget, calibre, calibre-web
module "downloader" {
  source       = "https://github.com/ProfessorSalty/terraform-homelab"
  name         = "downloader"
  target_node  = var.proxmox_primary
  vmid         = 506
  clone_source = local.ubuntu_docker_template
  cores        = 2
  memory       = 16384

  networks = [{
    model  = "virtio"
    bridge = var.downloader_bridge
  }]

  disks = [{
    size    = "64G"
    storage = local.DUMMY_DRIVE
    },
    {
      size    = "1500G"
      storage = local.storage_drive
    },
    {
      size    = "400G"
      storage = local.download_drive
  }]
}

# module "torrent" {
#     source = "./module/homelab"
#     name = "downloader"
#     target_node = var.proxmox_primary
#     vmid = 506
#     clone_source = local.ubuntu_docker_template
#     cores = 2
#     memory = 4096

#     networks = [{
#       bridge = var.torrent_bridge
#     }]
# }

# // nextcloud, papermerge, filestash
# module "office" {
#     source = "./module/homelab"
#     name = "office"
#     target_node = var.proxmox_secondary
#     vmid = 508
#     clone_source = local.ubuntu_docker_template
#     cores = 2
#     memory = 4096
# }

# module "bitwarden" {
#     name = "bitwarden"
#     target_node = var.proxmox_secondary
#     vmid = 509
#     clone_source = local.ubuntu_docker_template
#     cores = 4
#     memory = 4096
# }

# module "friendica" {
#     source = "./module/homelab"
#     name = "friendica"
#     target_node = var.proxmox_secondary
#     vmid = 510
#     clone_source = local.ubuntu_docker_template
#     cores = 4
#     memory = 4096
# }

# module "mastodon" {
#     source = "./module/homelab"
#     name = "mastodon"
#     target_node = var.proxmox_secondary
#     vmid = 511
#     clone_source = local.ubuntu_docker_template
#     cores = 4
#     memory = 4096
# }

# module "mailserver" {
#     source = "./module/homelab"
#     name = "mailserver"
#     target_node = var.proxmox_secondary
#     vmid = 513
#     clone_source = local.ubuntu_docker_template
#     cores = 4
#     memory = 4096
# }

# module "git" {
#     source = "./module/homelab"
#     name = "git"
#     target_node = var.proxmox_primary
#     vmid = 516
#     clone_source = local.ubuntu_docker_template
#     cores = 4
#     memory = 4096

#     disks = [{
#       size            = "50G"
#       type            = "scsi"
#       storage         = "disk1"
#     }]
# }

# // element, jitsi
# module "chat" {
#     source = "./module/homelab"
#     name = "chat"
#     target_node = var.proxmox_secondary
#     vmid = 515
#     clone_source = local.ubuntu_docker_template
#     cores = 4
#     memory = 4096
# }

# // home assistant, node RED, thingspeak
# module "automation" {
#     source = "./module/homelab"
#     name = "automation"
#     target_node = var.proxmox_secondary
#     vmid = 514
#     clone_source = local.ubuntu_docker_template
#     cores = 4
#     memory = 4096
# }
