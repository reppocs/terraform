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
  insecure = var.proxmox_insecure
  
  ssh {
    agent    = true
    username = var.proxmox_ssh_user
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  count       = 3
  name        = "kubes-vm-${count.index + 1}"
  node_name   = "pve"
  vm_id       = var.vm_id + count.index
  tags        = var.vm_tags
  
  clone {
    vm_id = var.template_vm_id  # Your template VM ID
  }
  
  cpu {
    cores = var.vm_cpu_cores
    type  = "host"
  }
  
  memory {
    dedicated = var.vm_memory_mb
  }
  
  disk {
    datastore_id = var.vm_datastore
    interface    = "scsi0"
    size         = var.vm_disk_size_gb
  }
  
  network_device {
    bridge = var.vm_network_bridge
  }
  
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.${var.vm_id + count.index}/24"
        gateway = var.vm_ipv4_gateway
      }
    }
    
    dns {
      servers = var.vm_dns_servers
    }
    
    user_account {
      username = var.vm_username
      password = var.vm_password
      keys     = var.vm_ssh_keys
    }
  }
  
  operating_system {
    type = "l26"
  }
}

output "vm_ips" {
  value = {
    for vm in proxmox_virtual_environment_vm.ubuntu_vm :
    vm.name => vm.ipv4_addresses[1][0]
  }
}
