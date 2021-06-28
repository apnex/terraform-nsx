#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="transport-zones"
valset "transport-zone.name"
valset "host-switch.name"
valset "transport-zone.type" "<[OVERLAY,VLAN]>"

# envs
if [[ -z "${TZNAME}" ]]; then
	TZNAME=${1}
fi
if [[ -z "${TZSWITCH}" ]]; then
	TZSWITCH=${2}
fi
if [[ -z "${TZTYPE}" ]]; then
	TZTYPE=${3}
fi

# body
function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"display_name":"$TZNAME",
		"host_switch_name":"$TZSWITCH",
		"description":"$TZTYPE Transport-Zone",
		"transport_type":"$TZTYPE"
	}
	CONFIG
	printf "${BODY}"
}

# run
run() {
	if [[ -n "${TZNAME}" && "${TZSWITCH}" && "${TZTYPE}" ]]; then
		BODY=$(makeBody)
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	else
		printf "[$(cgreen "ERROR")]: Command usage: $(cgreen "transport-zones.create") $(ccyan "<name> <switch> <type>")\n" 1>&2
	fi
}

# driver
driver "${@}"
