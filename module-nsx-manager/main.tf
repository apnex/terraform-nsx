data "vsphere_datacenter" "datacenter" {
	name          = var.datacenter
}

data "vsphere_datastore" "datastore" {
	name          = var.datastore
	datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
	name          = var.cluster
	datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
	name          = var.host
	datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
	name          = var.network
	datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_ovf_vm_template" "ovf" {
	name             = var.vm_name
	resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
	datastore_id     = data.vsphere_datastore.datastore.id
	host_system_id   = data.vsphere_host.host.id
	remote_ovf_url   = var.remote_ovf_url

	ovf_network_map = {
		"Network 1" = data.vsphere_network.network.id
	}
}

resource "vsphere_virtual_machine" "vm" {
	datacenter_id	= data.vsphere_datacenter.datacenter.id
	name		= data.vsphere_ovf_vm_template.ovf.name
	num_cpus	= data.vsphere_ovf_vm_template.ovf.num_cpus
	memory		= data.vsphere_ovf_vm_template.ovf.memory
	guest_id	= data.vsphere_ovf_vm_template.ovf.guest_id

	resource_pool_id = data.vsphere_ovf_vm_template.ovf.resource_pool_id
	datastore_id     = data.vsphere_ovf_vm_template.ovf.datastore_id
	host_system_id   = data.vsphere_ovf_vm_template.ovf.host_system_id

	dynamic "network_interface" {
		for_each = data.vsphere_ovf_vm_template.ovf.ovf_network_map
		content {
			network_id = network_interface.value
		}
	}
	ovf_deploy {
		disk_provisioning	= "thin"
		ovf_network_map		= data.vsphere_ovf_vm_template.ovf.ovf_network_map
		remote_ovf_url		= data.vsphere_ovf_vm_template.ovf.remote_ovf_url
	}
	vapp {
		properties = var.properties
	}
}
