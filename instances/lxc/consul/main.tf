module "consul-server" {
  source = "../template"

  hostname = "consul${var.consul_server_index}"

  target_node = var.target_node
  template_password = var.template_password

  pm_api_url = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  source_template = var.source_template
  data_storage_path = var.data_storage_path
}


