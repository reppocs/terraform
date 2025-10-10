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
  insecure  = var.proxmox_insecure
  
  ssh {
    agent    = true
    username = var.proxmox_ssh_user
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.proxmox_node
  vm_id     = var.vm_id
  tags      = var.vm_tags
  
  clone {
    vm_id = var.template_vm_id
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
    discard      = "on"
    ssd          = true
  }
  
  network_device {
    bridge = var.vm_network_bridge
  }
  
  initialization {
    ip_config {
      ipv4 {
        address = var.vm_ipv4_address
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

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, for example
      tags,
    ]
  }
}

output "vm_id" {
  description = "The ID of the created VM"
  value       = proxmox_virtual_environment_vm.vm.id
}

output "vm_name" {
  description = "The name of the created VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "vm_ip" {
  description = "The IPv4 address of the VM"
  value       = try(proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0], "N/A")
}
