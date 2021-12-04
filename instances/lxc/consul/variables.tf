variable "pm_api_url" {
  type = "string"
  default = ""
}

variable "pm_user_pass" {
  type = "string"
  sensitive = true
  default = ""
}

variable "source_template" {
  type = "string"
  default = ""
}

variable "data_storage_path" {
  type = "string"
  default = ""
}

variable "target_node" {
  type = "string"
  default = ""
}

variable "template_password" {
  type = "string"
  sensitive = true
  default = ""
}

variable "consul_server_index" {
  type = number
  default = 1
}
