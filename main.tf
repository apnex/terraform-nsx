terraform {
	required_providers {
		vsphere = "~> 1.26.0"
	}
}
provider "vsphere" {
	vsphere_server		= "vcenter.lab01.one"
	user			= "administrator@vsphere.local"
	password		= "VMware1!SDDC"
	allow_unverified_ssl	= true
}

module "nsx-manager" {
	source		= "./module-nsx-manager"

	### vsphere variables
	datacenter	= "core"
	cluster		= "core"
	datastore	= "ds-esx11"
	host		= "esx11.lab01.one"
	network		= "vss-vmnet"

	### appliance variables
	vm_name		= "nsx.lab01.one"
	remote_ovf_url	= "http://172.16.10.1:9000/iso/nsx-unified-appliance-3.1.2.1.0.17975796.ova"
	properties	= {
		nsx_hostname		= "nsx.lab01.one"
		nsx_role		= "NSX Manager"
		nsx_ip_0		= "172.16.10.117"
		nsx_netmask_0		= "255.255.255.0"
		nsx_gateway_0		= "172.16.10.1"
		nsx_dns1_0		= "172.16.10.1"
		nsx_ntp_0		= "172.16.10.1"
		nsx_passwd_0		= "VMware1!SDDC"
		nsx_cli_passwd_0	= "VMware1!SDDC"
		nsx_cli_audit_passwd_0	= "VMware1!SDDC"
		nsx_isSSHEnabled	= "True"
		nsx_allowSSHRootLogin	= "True"
	}
}
