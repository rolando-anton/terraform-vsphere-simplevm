# Terraform vSphere Module

Based on this: https://raw.githubusercontent.com/Terraform-VMWare-Modules/terraform-vsphere-vm/ but without the customization and with an small change to use vApps instead of regular resources pools.

## Deploys (Single/Multiple) Virtual Machines to your vSphere environment

This Terraform module deploys single or multiple virtual machines of type (Linux/Windows) with following features:

- Ability to add extra data disk (up to 15) to the VM.
- Ability to deploy Multiple instances.
- Ability to add multiple network cards for the VM
- Ability to output VM names and IPs per module.
- Ability to deploy either a datastore or a datastore cluster.
- Ability to define different datastores for data disks.
- Ability to define different scsi_controllers per disk, including data disks.
- Ability to define network type per interface and disk label per attached disk.
- Ability to define depend on using variable vm_depends_on

Tested witn Terraform 0.12
