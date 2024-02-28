terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      #latest version as of Nov 30 2022
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.url
  pm_api_token_id = var.token_id
  pm_api_token_secret = var.token_secret
  pm_tls_insecure = true
}

# Creates a proxmox_vm_qemu entity named tftest
resource "proxmox_vm_qemu" "virtual_machine" {
  name = "tftest"
  target_node = "pve"
  clone = "ubuntu-22.04-template"
  full_clone  = "true"

  agent = 0
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "20G"
    type = "scsi"
    format = "raw"
    storage = "local-data"
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.1.101/24,gw=192.168.1.1"
  nameserver = "192.168.1.100"
  searchdomain = "home.lab"
  sshkeys = var.ssh_pub_key

}
