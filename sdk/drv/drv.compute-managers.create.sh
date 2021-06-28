#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

## temp - hold vals
VSPHOST="vcenter.lab01.one"
VSPUSER="administrator@vsphere.local"
VSPPASS="VMware1!SDDC"

## temp - move back to drv core - needed for : (colon) separation of {2} values
PAYLOAD=$(echo -n | openssl s_client -connect "${VSPHOST}":443 2>/dev/null)
PRINT=$(echo "$PAYLOAD" | openssl x509 -noout -fingerprint -sha256)
REGEX='^(.*)=(([0-9A-Fa-f]{2}[:])+([0-9A-Fa-f]{2}))$'
if [[ $PRINT =~ $REGEX ]]; then
	TYPE=${BASH_REMATCH[1]}
	VSPPRINT=${BASH_REMATCH[2]}
fi

function makeBody {
	read -r -d '' PAYLOAD <<-CONFIG
	{
		"server": "$VSPHOST",
		"display_name": "$VSPHOST",
		"set_as_oidc_provider": true,
		"access_level_for_oidc": "FULL",
		"origin_type": "vCenter",
		"credential" : {
			"credential_type" : "UsernamePasswordLoginCredential",
			"username": "$VSPUSER",
			"password": "$VSPPASS",
			"thumbprint": "$VSPPRINT"
		}
	}
	CONFIG
	echo "${PAYLOAD}"
}

if [[ -n "${VSPHOST}" && "${VSPUSER}" && "${VSPPASS}" && "${VSPPRINT}" ]]; then
 	BODY=$(makeBody) ## makeURL ?

	ITEM="fabric/compute-managers"
	#URL="https://${APIENDPOINT}/api/v1/fabric/compute-managers"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
else
	printf "[$(cgreen "ERROR")]: Command usage: $(cgreen "compute-managers.join") $(ccyan "<transport-nodes.name> <node.id>")\n" 1>&2
fi

