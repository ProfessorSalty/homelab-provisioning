build {
  name = "centos"
  sources = ["source.proxmox.vm"]

  provisioner "ansible" {
    extra_arguments  = [
      "--extra-vars", "ansible_become_pass=\"${var.user_password}\"", 
      "--extra-vars", "public_key_file=${var.public_key_file}",
      "--extra-vars", "template_username=${var.template_username}"]
    galaxy_file      = "requirements.yml"
    playbook_file    = "${path.root}/centos-8-template.yml"
  }
}

