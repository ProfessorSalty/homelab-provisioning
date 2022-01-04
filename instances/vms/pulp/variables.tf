variable "pm_api_url" {
  type = string
  default = ""
}

variable "pm_user_pass" {
  type = string
  sensitive = true
  default = ""
}

variable "pm_user" {
  type = string
}

variable "data_storage_path" {
  type = string
}

variable "target_node" {
  type = string
}

variable "clone_source" {
  type = string
}

variable "template_password" {
  type = string
  sensitive = true
}

variable "ssh_public_key" {
  type = string
}

