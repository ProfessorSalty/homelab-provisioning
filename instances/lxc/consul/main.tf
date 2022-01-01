module "consul-server" {
  source = "../template"

  hostname = "consul${var.consul_server_index}"

  target_node = var.proxmox_node
  template_password = var.proxmox_token

  pm_api_url = "${local.proxmox_server_protocol}://${var.proxmox_host}:${local.proxmox_server_port}/api2/json"
  pm_user_pass = var.pm_user_pass
  
  source_template = var.source_template
  data_storage_path = var.data_storage_path
}


