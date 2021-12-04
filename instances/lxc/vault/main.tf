module "nomad" {
  source = "../template"

  hostname = "nomad-${var.nomad_server_index}"

  pm_api_url = var.pm_api_url
  pm_user_pass = var.pm_user_pass
  source_template = var.source_template
  data_storage_path = var.data_storage_path
  target_node = var.target_node
  template_password = var.template_password
}
