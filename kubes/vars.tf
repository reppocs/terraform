variable "url" {
  description = "proxmox api address url"
  default = "https://192.168.1.70:8006/api2/json"
}

variable "token_secret" {
}

variable "token_id" {
}

variable "ssh_pub_key" {
  default = <<EOF
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVdqDua/NOpQk7BFxIA1IYjcfx83X2rWy7NCPKhhdE0 reppocs@gmail.com
  EOF
}
