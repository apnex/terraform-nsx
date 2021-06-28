locals {
	sdk		= "${path.root}/../sdk/drv"
	state		= "${path.root}/../sdk/drv/state"
	tz-name		= var.tz-name
	tz-switch	= var.tz-switch
	tz-type		= var.tz-type
}

data "external" "transport-zone" {
	program = ["/bin/bash", "-c", <<-EOF
		## get resource
		PAYLOAD=$(${local.sdk}/drv.transport-zones.list.sh | jq '
			.results[]
			| select(.display_name=="${local.tz-name}")
		')

		## build values
		VALUE=$(echo -n $PAYLOAD | jq -r '.id')
		jq -n --arg id "$VALUE" '{
			"id": $id
		}'
	EOF
	]
	depends_on = [
		null_resource.transport-zone
	]
}

resource "null_resource" "transport-zone" {
	triggers = {
		sdk		= local.sdk
		tz-name		= local.tz-name
		tz-switch	= local.tz-switch
		tz-type		= local.tz-type
	}
	provisioner "local-exec" {
		interpreter	= ["/bin/bash", "-c"]
		command		= "${self.triggers.sdk}/drv.transport-zones.create.sh"
		environment	= {
			TZNAME		= self.triggers.tz-name
			TZSWITCH	= self.triggers.tz-switch
			TZTYPE		= self.triggers.tz-type
		}
	}
	provisioner "local-exec" {
		when		= destroy
		interpreter	= ["/bin/bash", "-c"]
		command		= <<-EOT
			## get resource id
			PAYLOAD=$(${self.triggers.sdk}/drv.transport-zones.list.sh | jq '
				.results[]
				| select(.display_name=="${self.triggers.tz-name}")
			')
			ID=$(echo -n $PAYLOAD | jq -r '.id')
			## delete compute-manager
			${self.triggers.sdk}/drv.transport-zones.delete.sh $ID
		EOT
	}
}

output "id" {
	value = data.external.transport-zone.result.id
}
