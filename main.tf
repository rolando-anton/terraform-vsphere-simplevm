data "vsphere_datacenter" "dc" {
  name = var.dc
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  count         = var.ds_cluster != "" ? 1 : 0
  name          = var.ds_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  count         = var.datastore != "" && var.ds_cluster == "" ? 1 : 0
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "disk_datastore" {
  count         = var.disk_datastore != "" ? 1 : 0
  name          = var.disk_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "data_disk_datastore" {
  for_each      = toset(var.data_disk_datastore)
  name          = each.key
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_network" "network" {
  count         = var.network_cards != null ? length(var.network_cards) : 0
  name          = var.network_cards[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_virtual_machine" "template" {
  name          = var.vmtemp
  datacenter_id = data.vsphere_datacenter.dc.id
}


locals {
  interface_count     = length(var.ipv4submask) #Used for Subnet handeling
  template_disk_count = length(data.vsphere_virtual_machine.template.disks)
}


resource "vsphere_virtual_machine" "vm" {
  count                       = var.instances
  name       = "%{if var.vmnameliteral != ""}${var.vmnameliteral}%{else}${var.vmname}${count.index + 1}${var.vmnamesuffix}%{endif}"
  resource_pool_id  = var.vmrp
  datastore_id         = var.datastore != "" ? data.vsphere_datastore.datastore[0].id : null
  num_cpus               = var.cpu_number
  memory                 = var.ram_size
  wait_for_guest_net_timeout  = 0
  wait_for_guest_net_routable = false
  nested_hv_enabled           = var.nested_hv_enabled
  force_power_off             = true
  depends_on                  = [var.vm_depends_on]
  guest_id                    = data.vsphere_virtual_machine.template.guest_id

  dynamic "network_interface" {
    for_each = var.network_cards
    content {
      network_id   = data.vsphere_network.network[network_interface.key].id
      adapter_type = var.network_type != null ? var.network_type[network_interface.key] : data.vsphere_virtual_machine.template.network_interface_types[0]
    }
  }


  // Disks defined in the original template

  dynamic "disk" {
    for_each = data.vsphere_virtual_machine.template.disks
    iterator = template_disks
    content {
      label            = length(var.disk_label) > 0 ? var.disk_label[template_disks.key] : "disk${template_disks.key}"
      size             = data.vsphere_virtual_machine.template.disks[template_disks.key].size
      unit_number      = var.scsi_controller != null ? var.scsi_controller * 15 + template_disks.key : template_disks.key
      thin_provisioned = data.vsphere_virtual_machine.template.disks[template_disks.key].thin_provisioned
      eagerly_scrub    = data.vsphere_virtual_machine.template.disks[template_disks.key].eagerly_scrub
      datastore_id     = var.disk_datastore != "" ? data.vsphere_datastore.disk_datastore[0].id : null
    }
  }

  // Additional disks defined by Terraform config
  dynamic "disk" {
    for_each = var.data_disk_size_gb
    iterator = terraform_disks
    content {
      label            = length(var.data_disk_label) > 0 ? var.data_disk_label[terraform_disks.key] : "disk${terraform_disks.key + local.template_disk_count}"
      size             = var.data_disk_size_gb[terraform_disks.key]
      unit_number      = length(var.data_disk_scsi_controller) > 0 ? var.data_disk_scsi_controller[terraform_disks.key] * 15 + terraform_disks.key + (var.scsi_controller == var.data_disk_scsi_controller[terraform_disks.key] ? local.template_disk_count : 0) : terraform_disks.key + local.template_disk_count
      thin_provisioned = var.thin_provisioned != null ? var.thin_provisioned[terraform_disks.key] : null
      eagerly_scrub    = var.eagerly_scrub != null ? var.eagerly_scrub[terraform_disks.key] : null
      datastore_id     = length(var.data_disk_datastore) > 0 ? data.vsphere_datastore.data_disk_datastore[var.data_disk_datastore[terraform_disks.key]].id : null
    }
  }


  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

}
