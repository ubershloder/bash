#!/bin/bash
#user deletor

#check root
if [[ "${UID}" -ne 0 ]]
then
	echo 'ure not root! use sudo'
	exit 1
fi
#assume arg (user to del)
USER="${1}"

#delete

userdel ${USER}

#check if deleted
if [[ "${?}" -ne 0 ]]
then 
	echo "not deleted ${USER}" >&2
	exit 1
fi
echo "the acc ${USER} was deleted"
