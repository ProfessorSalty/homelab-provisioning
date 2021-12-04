proxmox_username = "${consul_key("proxmox/username")}"
proxmox_password = "${consul_key("proxmox/password")}"
proxmox_url = "${consul_key("proxmox/url")}"

vm_user_password = "${consul_key("homelab/user_password")}"
vm_user_name = "${consul_key("homelab/user_name")}"
syslog_server_address = "${consul_key("homelab/syslog_server_address")}"
apt_proxy_address = "${consul_key("homelab/apt_proxy_address")}"
