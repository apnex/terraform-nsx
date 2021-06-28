locals {
	sdk		= "${path.root}/../sdk/drv"
	state		= "${path.root}/../sdk/drv/state"
	vcenter-fqdn	= var.vcenter-fqdn
	vcenter-user	= var.vcenter-user
	vcenter-pass	= var.vcenter-pass
}

data "external" "compute-manager-get" {
	program = ["/bin/bash", "-c", <<-EOF
		## get compute-manager
		PAYLOAD=$(${local.sdk}/drv.compute-managers.list.sh | jq '
			.results[]
			| select(.server=="${local.vcenter-fqdn}")
		')

		## build values
		VALUE=$(echo -n $PAYLOAD | jq -r '.id')
		jq -n --arg id "$VALUE" '{
			"id": $id
		}'
	EOF
	]
	depends_on = [
		null_resource.compute-manager
	]
}

resource "null_resource" "compute-manager" {
	triggers = {
		sdk		= local.sdk
		vcenter-fqdn	= local.vcenter-fqdn
		vcenter-user	= local.vcenter-user
		vcenter-pass	= local.vcenter-pass
	}
	provisioner "local-exec" {
		interpreter	= ["/bin/bash", "-c"]
		command		= "${self.triggers.sdk}/drv.compute-managers.create.sh"
		environment	= {
			ENDPOINT	= self.triggers.vcenter-fqdn
			USERNAME	= self.triggers.vcenter-user
			PASSWORD	= self.triggers.vcenter-pass
		}
	}
	provisioner "local-exec" {
		when		= destroy
		interpreter	= ["/bin/bash", "-c"]
		command		= <<-EOT
			## get compute-manager id
			PAYLOAD=$(${self.triggers.sdk}/drv.compute-managers.list.sh | jq '
				.results[]
				| select(.server=="${self.triggers.vcenter-fqdn}")
			')
			ID=$(echo -n $PAYLOAD | jq -r '.id')
			## delete compute-manager
			${self.triggers.sdk}/drv.compute-managers.delete.sh $ID
		EOT
	}
}

output "id" {
	value = data.external.compute-manager-get.result.id
}
