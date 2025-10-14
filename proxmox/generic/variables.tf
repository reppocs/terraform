# Proxmox Provider Variables
variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification"
  type        = bool
  default     = true
}

variable "proxmox_ssh_user" {
  description = "SSH username for Proxmox"
  type        = string
  default     = "root"
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

# VM Configuration Variables
variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "my_vm"
}

variable "vm_id" {
  description = "VM ID"
  type        = number
  default     = 170
}

variable "template_vm_id" {
  description = "Template VM ID to clone from"
  type        = number
  default     = 9000
}

variable "vm_cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "vm_memory_mb" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "vm_disk_size_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 25
}

variable "vm_datastore" {
  description = "Datastore for VM disk"
  type        = string
  default     = "local-lvm"
}

variable "vm_network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "vm_tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = ["terraform", "test"]
}

# Network Configuration
variable "vm_ipv4_address" {
  description = "IPv4 address with CIDR"
  type        = string
  default     = "192.168.1.170/24"
}

variable "vm_ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string
  default     = "192.168.1.1"
}

variable "vm_dns_servers" {
  description = "DNS servers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

# User Configuration
variable "vm_username" {
  description = "VM username"
  type        = string
  default     = "corey"
}

variable "vm_password" {
  description = "VM user password"
  type        = string
  sensitive   = true
}

variable "vm_ssh_keys" {
  description = "List of SSH public keys"
  type        = list(string)
  default     = []
}
