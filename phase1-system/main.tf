module "compute-manager" {
	source		= "./mod-compute-manager"

	### variables
	vcenter-fqdn	= "vcenter.lab01.one"
	vcenter-user	= "administrator@vsphere.local"
	vcenter-pass	= "VMware1!SDDC"
}

module "transport-zone" {
	source		= "./mod-transport-zone"

	### variables
	tz-name		= "tz-hahhatest"
	tz-switch	= "hs-fabric"
	tz-type		= "VLAN"
}
