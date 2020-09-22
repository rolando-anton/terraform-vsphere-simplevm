variable "cpu_number" {
  description = "number of CPU (core per CPU) for the VM."
  default     = 2
}

variable "vmname" {
  description = "The name of the virtual machine used to deploy the vms."
  default     = "terraformvm"
}

variable "vmnamesuffix" {
  description = "vmname suffix after numbered index coming from instance variable."
  default     = ""
}

variable "vmnameliteral" {
  description = "vmname without any suffix or Prefix, only to be used for single instances."
  default     = ""
}

variable "vmtemp" {
  description = "Name of the template available in the vSphere."
}

variable "instances" {
  description = "number of instances you want deploy from the template."
  default     = 1
}


variable "ram_size" {
  description = "VM RAM size in megabytes."
  default     = 4096
}

variable "network_cards" {
  description = ""
  type        = list(string)
}


variable "dc" {
  description = "Name of the datacenter you want to deploy the VM to."
}

variable "vmrp" {
  description = "Cluster resource pool that VM will be deployed to. you use following to choose default pool in the cluster (esxi1) or (Cluster)/Resources."
}

variable "ds_cluster" {
  description = "Datastore cluster to deploy the VM."
  default     = ""
}

variable "datastore" {
  description = "Datastore to deploy the VM."
  default     = ""
}


variable "vmfolder" {
  description = "The path to the folder to put this virtual machine in, relative to the datacenter that the resource pool is in."
  default     = null
}

variable "disk_label" {
  description = "Storage data disk labels."
  type        = list
  default     = []
}

variable "data_disk_label" {
  description = "Storage data disk labels."
  type        = list
  default     = []
}

variable "data_disk_size_gb" {
  description = "List of Storage data disk size."
  type        = list
  default     = []
}

variable "disk_datastore" {
  description = "Define where the OS disk should be stored."
  type        = string
  default     = ""
}

variable "data_disk_datastore" {
  description = "Define where the data disk should be stored, should be equal to number of defined data disks."
  type        = list
  default     = []
  # validation {
  #   condition     = length(var.disk_datastore) == 0 || length(var.disk_datastore) == length(var.data_disk_size_gb)
  #       error_message = "The list of disk datastore must be equal in length to disk_size_gb"
  # }
}

variable "network_type" {
  description = "Define network type for each network interface."
  type        = list
  default     = null
}

variable "wait_for_guest_net_routable" {
  description = "Controls whether or not the guest network waiter waits for a routable address. When false, the waiter does not wait for a default gateway, nor are IP addresses checked against any discovered default gateways as part of its success criteria. This property is ignored if the wait_for_guest_ip_timeout waiter is used."
  type        = bool
  default     = true
}

variable "wait_for_guest_ip_timeout" {
  description = "The amount of time, in minutes, to wait for an available guest IP address on this virtual machine. This should only be used if your version of VMware Tools does not allow the wait_for_guest_net_timeout waiter to be used. A value less than 1 disables the waiter."
  type        = number
  default     = 0
}

variable "wait_for_guest_net_timeout" {
  description = "The amount of time, in minutes, to wait for an available IP address on this virtual machine's NICs. Older versions of VMware Tools do not populate this property. In those cases, this waiter can be disabled and the wait_for_guest_ip_timeout waiter can be used instead. A value less than 1 disables the waiter."
  type        = number
  default     = 5
}

variable "ignored_guest_ips" {
  description = "List of IP addresses and CIDR networks to ignore while waiting for an available IP address using either of the waiters. Any IP addresses in this list will be ignored if they show up so that the waiter will continue to wait for a real IP address."
  type        = list(string)
  default     = []
}

variable "vm_depends_on" {
  description = "Add any external depend on module here like vm_depends_on = [module.fw_core01.firewall]."
  type        = any
  default     = null
}

variable "nested_hv_enabled" {
  description = "Enable nested hardware virtualization on this virtual machine, facilitating nested virtualization in the guest."
  type        = bool
  default     = null
}

variable "force_power_off" {
  description = "If a guest shutdown failed or timed out while updating or destroying (see shutdown_wait_timeout), force the power-off of the virtual machine."
  type        = bool
  default     = null
}


variable "thin_provisioned" {
  description = "If true, this disk is thin provisioned, with space for the file being allocated on an as-needed basis."
  type        = list
  default     = null
}

variable "scsi_type" {
  description = "scsi_controller type, acceptable values lsilogic,pvscsi."
  type        = string
  default     = ""
}

variable "scsi_controller" {
  description = "scsi_controller number for the main OS disk."
  type        = number
  default     = 0
  # validation {
  #   condition     = var.scsi_controller < 4 && var.scsi_controller > -1
  #       error_message = "The scsi_controller must be between 0 and 3"
  # }
}

variable "ipv4" {
  description = "host(VM) IP address in map format, support more than one IP. Should correspond to number of instances."
  type        = map
}

variable "data_disk_scsi_controller" {
  description = "scsi_controller number for the data disk, should be equal to number of defined data disk."
  type        = list
  default     = []
  # validation {
  #   condition     = max(var.data_disk_scsi_controller...) < 4 && max(var.data_disk_scsi_controller...) > -1
  #       error_message = "The scsi_controller must be between 0 and 3"
  # }
}

variable "ipv4submask" {
  description = "ipv4 Subnet mask."
  type        = list
  default     = ["24"]
}

variable "eagerly_scrub" {
  description = "if set to true, the disk space is zeroed out on VM creation. This will delay the creation of the disk or virtual machine. Cannot be set to true when thin_provisioned is true."
  type        = list
  default     = null
}

