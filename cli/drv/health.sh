#!/bin/bash
while [[ -z $CSRFTOKEN ]]; do
	CSRFHEADER=$(curl -kvs -X GET "https://avic.lab01.one" 2>&1 | grep set-cookie | grep csrftoken)
	if [[ $CSRFHEADER =~ csrftoken=([A-Za-z0-9]+) ]]; then
		CSRFTOKEN=${BASH_REMATCH[1]}
		printf "%s\n" "X-CSRFToken [[ $CSRFTOKEN ]]"
	else
		printf "%s\n" "Waiting for API to respond.. sleep 20"
		sleep 20
	fi
done
