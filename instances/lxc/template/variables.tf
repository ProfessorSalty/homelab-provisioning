variable "pm_user_pass" {
  sensitive = true
  type      = string
}

variable "pm_api_url" {
  type = string
}

variable "pm_user" {
  type = string
  validation {
    condition = can(regex("@(pam|pve)$", var.pm_user))
    error_message = "Please enter the full username with the authentication domain (@pve, @pam, etc.)."
  }
}

variable "ssh_public_key" {
  type = string
  default = ""
}

variable "data_storage" {
  type = string
  default = "local-lvm"
  description = "Where on the host the data will be stored. (default local-lvm)"
}

variable "data_storage_path" {
  type = string
  description = "Path to the mount point as seen from inside the container."
}

variable "network_name" {
  type = string
  default = "eth0"
  description = "The name of the network interface as it appears in the container (default eth0)"
}

variable "network_bridge" {
  type = string
  default = "vmbr0"
  description = "The name of the host bridge to use (default vmbr0)"
}

variable "network_ipv4" {
  type = string
  default = "dhcp"
  description = "Define a static IPv4 address (default dhcp)"
}

variable "target_node" {
  type = string
}

variable "hostname" {
  type    = string
}

variable "source_template" {
  type  = string
}

variable "template_password" {
  sensitive = true
  type    = string
}

variable "template_storage" {
  type = string
  default = "local"
  description = "Where on the host the template is store (default local)"
}

variable "root_storage" {
  type = string
  default = "local-lvm"
  description = "Where on the host to store the root filesystem (default local)"
}

variable "root_storage_size" {
  type = number
  default = 16
  description = "Size of root storage drive in gigabytes (default 16)"
}

variable "data_storage_size" {
  type = number
  default = 16
  description = "Size of data storage drive in gigabytes (default 16)"
}
