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

local "hostname" {
  type = string
  default = "ubuntu-20-04-template"
}

source "proxmox" "ubuntu2004template" {
  # proxmox auth
  node        = var.proxmox_node
  username    = var.proxmox_username
  token       = var.proxmox_token
  node        = var.proxmox_node
  proxmox_url = "${var.proxmox_server_protocol}://${var.proxmox_host}:${var.proxmox_server_port}/api2/json"

  # metadata
  template_description = var.proxmox_template_description
  template_name        = var.template_name
  os                   = var.os
  vm_id                = var.proxmox_vm_id

  # cloud_init
  cloud_init              = var.cloud_init
  cloud_init_storage_pool = var.storage_pool
  http_content            = {
    'meta-data' = ''
    'user-data' = templatefile('user-data.pkrtmpl', {
      template_user : {
        name : local.template_username,
        password : var.user_password,
      },
      root_password : var.root_password,
      controller_ssh_pub_key : file(var.controller_ssh_pub_key_file),
      hostname: local.hostname,
      apt_proxy_address: var.pulp_server,
      timezone : var.timezone
    })
  }
  boot_command            = "<esc><wait><esc><wait><f6><wait><esc><wait><bs><bs><bs><bs><bs> autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ --- <enter>,"
  boot_wait               = "6s"

  # build settings
  qemu_agent  = true
  unmount_iso = true
  iso_file    = "${var.iso_storage}:iso/${var.iso_file}"

  # connection settings
  ssh_password = var.user_password
  ssh_username = local.template_username
  ssh_timeout  = "90m"

  # machine config
  cores           = 1
  memory          = 2048
  scsi_controller = "virtio-scsi"

  disks {
    disk_size         = var.main_drive_size
    format            = "raw"
    storage_pool      = var.storage_pool
    storage_pool_type = "lvm-thin"
    type              = "scsi"
  }

  network_adapters {
    bridge = var.network_bridge
    model  = "virtio"
  }
}

build {
  sources = ["source.proxmox.vm"]
  name    = "ubuntu"

  provisioner "shell" {
    # kind of a hack to force the provisioner to wait for cloud-init to finish
    inline = [
      "while [ ${var.cloud_init == true} && ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"
    ]
  }

  provisioner "ansible" {
    extra_arguments = [
      "--extra-vars", "ansible_become_pass=\"${var.user_password}\"",
      "--extra-vars", "ansible_ssh_pass=\"${var.user_password}\"",
      "--extra-vars", "public_key_file=${var.public_key_file}",
      "--extra-vars", "syslog_server_address=${var.syslog_server_address}",
      "--extra-vars", "template_username=${var.template_username}",
    ]
    galaxy_file     = "ansible/requirements/${var.template_name}-requirements.yml"
    playbook_file   = "ansible/playbooks/${var.template_name}.yml"
  }
}

