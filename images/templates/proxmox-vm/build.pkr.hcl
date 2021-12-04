build {
  sources = ["source.proxmox.vm"]

  provisioner "shell" {
    inline = ["while [ ${var.cloud_init} && ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"]
  }

  provisioner "ansible" {
    extra_arguments  = ["--extra-vars", "ansible_become_pass=\"${var.user_password}\"", "--extra-vars", "ansible_ssh_pass=\"${var.user_password}\"", "--extra-vars", "public_key_file=${var.public_key_file}", "--extra-vars", "syslog_server_address=${var.syslog_server_address}", "--extra-vars", "template_username=${var.template_username}", "-vvvv"]
    galaxy_file      = "ansible/requirements/${var.template_name}-requirements.yml"
    playbook_file    = "ansible/playbooks/${var.template_name}.yml"
  }
}

