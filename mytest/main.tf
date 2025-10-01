terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure = true
  
  ssh {
    agent    = true
    username = "root"
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name        = "ubuntu-vm"
  node_name   = "pve"
  vm_id       = 160
  
  clone {
    vm_id = 9000  # Your template VM ID
  }
  
  cpu {
    cores = 2
  }
  
  memory {
    dedicated = 2048
  }
  
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 25
  }
  
  network_device {
    bridge = "vmbr0"
  }
  
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.160/24"
        gateway = "192.168.1.1"
      }
    }
    
    dns {
      servers = ["8.8.8.8", "8.8.4.4"]
    }
    
    user_account {
      username = "corey"
      password = var.vm_password
      keys     = [
        trimspace(file("~/.ssh/id_ed25519.pub"))
      ]
    }
  }
  
  operating_system {
    type = "l26"
  }
}

output "vm_ip" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses[1][0]
}
