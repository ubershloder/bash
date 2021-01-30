#!/bin/bash
#
#This ping all the servers and reports status

SERVER_FILE='/vagrant/servers'

if [[ ! -e "${SERVER_FILE}" ]]
then
	echo "Cant open ${SERVER_FILE}" >&2
	exit 1
fi

for SERVER in $(cat ${SERVER_FILE})
do
	echo "Pinging ${SERVER}"
	ping -c 1 ${SERVER} &>/dev/null
	if [[ "${?}" -ne 0 ]]
	then
		echo "${SERVER} maybe down or check firewall"
	else
		echo "${SERVER} is fine"
	fi
done

