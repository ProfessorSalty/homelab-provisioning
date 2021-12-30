variable "pm_api_url" {
  type = "string"
}

variable "pm_user" {
  type = "string"
}

variable "pm_user_pass" {
  type = "string"
  sensitive = true
}

variable "source_template" {
  type = "string"
}

variable "data_storage_path" {
  type = "string"
  default = ""
}

variable "target_node" {
  type = "string"
}

variable "template_password" {
  type = "string"
  sensitive = true
  default = ""
}

variable "nomad_server_index" {
  type = number
  default = 0
}
