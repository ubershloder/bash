#!/bin/bash

# generates random pass
#this user can change pass lenght with -l add a special char 
#verbose can be enabled with -v.

#functions for script
usage () {
	echo "Usage : of password-generator [-vs] [-l LENGHT]" >&2
	echo '-l sepecify the password lenght'
	echo '-s append a special character'
	echo '-v insrease vesrosity'
	exit 1
}
log (){
	local MESSAGE="${@}"
if [[ "${VERBOSE}" = 'true' ]]
then
	echo "${MESSAGE}" 
fi
}
#set default pass lenght
LENGHT=48

while getopts vl:s OPTION
do
	case ${OPTION} in
		v)
			VERBOSE='true'
			log 'Verbose is on'
			;;
		l) 
			LENGHT="${OPTAGS}"
			;;
		s)
			USE_SPECIAL_CHARACTER='true'
			;;
		?)
			usage
			;;
	esac
done

#remove options while leaving args
shift "$(( OPTIND - 1 ))"
#check for args
if [[ "${#}" -gt 0 ]]
then
	usage
fi

log 'Generating a password.'

PASSWORD=$( date +%s%N${RANDOM}${RAMDOM} | sha256sum | head -c${LENGHT} )
#add special char
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
	log 'Selectig random spec char'
	SPECIAL_CHARACTER=$(echo '!@#$%^&*()-+=' | fold -w1 | shuf | head -c1)
PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Here is password:'
echo "${PASSWORD}"

exit 0
