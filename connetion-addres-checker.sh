#!/bin/bash

#count num of failed logins by ip
#if there are any ip with over limit show info

LIMIT='10'
LOG_FILE="${1}"

#make sure if a file exists
if [[ ! -e "${LOG_FILE}" ]]
then 
	echo "cant open log file: ${LOG_FILE}"
	exit 1
fi
#Display the CSV
echo 'Count,IP,Location'

#loop through the list of failed attempts
grep Failed syslog-sample | awk '{print $(NF -3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do 
# if the num if fails more then limit then show info
if [[ "${COUNT}" -gt "${LIMIT}" ]]
then
	LOCATION=$(geoiplookup ${IP} | awk -F ', ' {print $2})
	echo "${COUNT}, ${IP}, ${LOCATION}"
fi
done
exit 0
