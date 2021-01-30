#!/bin/bash

# A list of servers one per line
SERVER_LIST='/vagrant/servers'

#options for ssh
SSH_OPTIONS='-o ConnectTimeout=2 '

usage(){
#Show usage
	echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
	echo 'Executes COMMAND as  single command on every server' >&2
	echo "	-f FILE Use file for the list of servers. Default is ${SERVER_LIST} " >&2
	echo '  -n     Dry run mode. Display the COMMAND that will be executed' >&2
	echo '  -s     Execute the COMMAND using sudo on servers' >&2
	echo '  -v     Verbose mode. Shows also a server name' >&2
	exit 1

}
#make sure non root
if [[ "${UID}" -eq 0 ]]
then
	echo 'Its non root script...' >&2
	usage
fi
#parse options
while getopts f:nsv OPTION
do
	case ${OPTION} in
		f) SERVER_LIST="${OPTARG}"
			;;
		n) DRY_RUN='true'
			;;
		s) SUDO='sudo'
			;;
		v) VERBOSE='true'
			;;
		?) usage
			;;
	esac
done

#Revome the options while leaving args
shift "$(( OPTIND - 1 ))"

#If user dont supply args
if [[ "${#}" -lt 1 ]]
then
	usage
fi
# Anything else is the command line to be like  single command
COMMAND="${@}"

#Check if file exists
if [[ ! -e "${SERVER_LIST}" ]]
then
	echo "Cannot open server list file ${SERVER_LIST}" >&2
	exit 1
fi
EXIT_STATUS='0'

#Loop SERVER_LIST
for SERVER in $(cat ${SERVER_LIST})
	do
		if [[ "${VERBOSE}" = 'true' ]]
		then
			echo "${SERVER}"
		fi
		SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"

		#if dry run then dont run anyting
		if [[ "${DRY_RUN}" = 'true' ]]
		then
			echo "Dry run: ${SSH_COMMAND}"
		else 
			${SSH_COMMAND}
			SSH_EXIT_STATUS="${?}"
		#capture any non zeros
		if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
		then
			EXIT_STATUS=${SSH_EXIT_STATUS}
			echo "Execution fail on ${SERVER}" >&2
		fi
	fi
done
exit ${EXIT_STATUS}

		
