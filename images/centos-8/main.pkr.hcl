packer {
  required_plugins {
    proxmox = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/proxmox"
    }

    ansible = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

locals {
  ansible_requirements_file = "${path.root}/../../lib/requirements.yml"
  ansible_playbook_file     = "${path.root}/playbook.yml"
  proxmox_url               = "${var.proxmox_server_protocol}://${var.proxmox_host}:${var.proxmox_server_port}/api2/json"
  boot_command              = ["<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  boot_wait                 = "6s"
  os                        = "l26"
  iso_file_path             = "${var.iso_storage}:iso/${var.iso_file}"
  ssh_timeout               = "90m"
  scsi_controller           = "virtio-scsi-pci"
  main_disk_format          = "raw"
  storage_pool_type         = "lvm-thin"
  main_disk_type            = "scsi"
  network_adapter_model     = "virtio"
  proxmox_username_token    = "${var.proxmox_user}!${var.proxmox_api_token.id}"
  http_content              = {
    "/ks.cfg" = templatefile("ks.pkrtmpl", {
      template_user : {
        name : var.template_username,
        password : var.template_user_password,
      },
      root_password : var.root_password,
      controller_ssh_pub_key_file : file(var.controller_ssh_pub_key_file),
      timezone : var.timezone,
      hostname : var.hostname
    })
  }
}

source "proxmox" "centos8template" {
  # proxmox auth
  node        = var.proxmox_node
  username    = local.proxmox_username_token
  token       = var.proxmox_api_token.secret
  proxmox_url = local.proxmox_url

  # metadata
  template_description = var.template_description
  template_name        = var.template_name
  vm_id                = var.proxmox_vm_id
  os                   = local.os

  # cloud_init
  cloud_init              = var.cloud_init
  cloud_init_storage_pool = var.storage_pool
  boot_command            = local.boot_command
  boot_wait               = local.boot_wait
  http_content            = local.http_content

  # build settings
  qemu_agent  = true
  unmount_iso = true
  iso_file    = local.iso_file_path

  # connection settings
  ssh_timeout  = local.ssh_timeout
  ssh_password = var.template_user_password
  ssh_username = var.template_username

  # machine config
  cores           = 1
  memory          = 2048
  scsi_controller = local.scsi_controller

  disks {
    disk_size         = var.main_drive_size
    format            = local.main_disk_format
    storage_pool_type = local.storage_pool_type
    type              = local.main_disk_type
    storage_pool      = var.storage_pool
  }

  network_adapters {
    bridge = var.network_bridge
    model  = local.network_adapter_model
  }
}

build {
  name    = "centos"
  sources = ["source.proxmox.centos8template"]

    provisioner "ansible" {
      galaxy_file     = local.ansible_requirements_file
      playbook_file   = local.ansible_playbook_file
    }
}

variable "proxmox_server_protocol" {
  type    = string
  default = "https"
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_server_port" {
  type    = number
  default = 8006
}

variable "iso_storage" {
  type    = string
  default = "local-lvm"
}

variable "template_username" {
  type = string
}

variable "template_user_password" {
  type      = string
  sensitive = true
}

variable "root_password" {
  type      = string
  sensitive = true
}

variable "controller_ssh_pub_key_file" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "timezone" {
  type = string
}

variable "hostname" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_user" {
  type = string
}

variable "proxmox_api_token" {
  type = object({
    id     = string
    secret = string
  })
}

variable "template_description" {
  type = string
}

variable "template_name" {
  type = string
}

variable "proxmox_vm_id" {
  type = number
}

variable "cloud_init" {
  type    = bool
  default = true
}

variable "iso_file" {
  type = string
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "template-name" {
  type = string
}

variable "main_drive_size" {
  type    = string
  default = "32G"
}
