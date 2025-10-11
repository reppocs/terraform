terraform {
  required_version = ">= 1.0"
  
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true
  
  ssh {
    agent    = true
    username = "root"
  }
}

resource "proxmox_virtual_environment_vm" "k8s_nodes" {
  count     = 3
  name      = "k8s-node-${count.index + 1}"
  node_name = "pve"
  vm_id     = 180 + count.index
  tags      = ["kubernetes", "testing"]
  
  clone {
    vm_id = 9000
  }
  
  cpu {
    cores = 2
    type  = "host"
  }
  
  memory {
    dedicated = 4096
  }
  
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 50
    discard      = "on"
    ssd          = true
  }
  
  network_device {
    bridge = "vmbr0"
  }
  
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.${180 + count.index}/24"
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
        file("~/.ssh/id_ed25519.pub")
      ]
    }
  }
  
  operating_system {
    type = "l26"
  }
}

output "k8s_nodes" {
  description = "Kubernetes node details"
  value = {
    for vm in proxmox_virtual_environment_vm.k8s_nodes :
    vm.name => {
      id = vm.vm_id
      ip = try(vm.ipv4_addresses[1][0], "192.168.1.${180 + vm.vm_id}")
    }
  }
}
