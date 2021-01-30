#!/bin/bash


# check root
if [[ "${UID}" -ne 0 ]]
then
	echo "ure not root" >&2
	exit 1
fi


# check for args
if [[ "${#}" -lt 1 ]]
then
	echo "give args ${0} USER_NAME [COMMENT]..." >&2
	exit 1
fi

# add  to parm
USER_NAME="${1}"

#rest parm for acc comments
shift
COMMENT="${@}"

# generate a password
PASSWORD=$(date +%s%N | sha256sum | head -c20)

#make acc
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

#check for return 
if [[ "${?}" -eq 1 ]]
then 
	echo "someting went wrong with account creation" >&2
	exit 1
fi

#set pass
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &>/dev/null

#check if pass works
if [[ "${?}" -eq 1 ]]
then 
	echo "someting went wrong with password" >&2
	exit 1
fi

#force change
passwd -e ${USER_NAME} &> /dev/null

# display info
echo 'username'
echo "${USER_NAME}"
echo
echo 'password'
echo "${PASSWORD}"
echo
echo 'hostname'
echo "${HOSTNAME}"
echo
echo 'name of user'
echo "${COMMENT}"
exit 0
