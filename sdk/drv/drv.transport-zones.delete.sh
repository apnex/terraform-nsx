#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="transport-zones"
valset "transport-zone" "<transport-zones.id>"

# body
ID=${1}

# run
run() {
	if [[ -n "${ID}" ]]; then
		URL=$(buildURL "${ITEM}")
		URL+="/${ID}"
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxDelete "${URL}"
		fi
	else
		printf "[$(cgreen "ERROR")]: Command usage: $(cgreen "transport-zones.delete") $(ccyan "<id>")\n" 1>&2
	fi
}

# driver
driver "${@}"
