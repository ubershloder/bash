#!/bin/bash
ARCHIVE_DIR=/backups
BUCKETNAME=ubersholder-backups
USERNAME=uber
AWS_ACCESS_KEY_ID=123
REGION=eu-central-1
AWS_SECRET_ACCESS_KEY=123
HOME_DIR="/home/${USERNAME}"
ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}"

# usage function
usage(){

    echo 'aws-cli must be configured and user must have S3 write access' >&2

	echo 'My back up tool that uses S3 as endpoint location' >&2

	echo 'Just archives /home and sends it to /backups if it exists, if not then creates and then sends to S3' >&2

}
usage

# check if root(must be root)
if [[ "${UID}" -ne 0 ]]
then
	echo 'Sorry you are not root, try again using sudo' >&2
	exit 1
fi

#check if dir exists
if [[ ! -d  "${ARCHIVE_DIR}" ]]
then
	echo 'Lets go check if folder exists and create if it does not'
	mkdir -p "${ARCHIVE_DIR}"
	if [[ "${?}" -ne 0 ]]
	then
		echo 'Something went wrong, check permissions' >&2

	fi 
fi

# backup
if [[ -d "${HOME_DIR}" ]]
then
	echo "Archiving ${HOME_DIR} of user ${USERNAME} to ${ARCHIVE_FILE}"
	tar --exclude=".*" -zvcf ${ARCHIVE_FILE} ${HOME_DIR} 
	if [[ "${?}" != 0 ]]
	then
		echo "Can't create backup for ${USERNAME}" >&2
		exit 1

	fi
fi

# send to s3 
sent_toS3(){
    backup=$(ls -Art | tail -n 1)
    aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
    aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
    aws configure set region ${REGION}
    aws configure set output "text"
    /usr/bin/aws s3 cp ${ARCHIVE_FILE} s3://$BUCKETNAME
    if [[ "${?}" -eq 0 ]]
	then
        echo 'sent to S3'
    else
        echo 'some error'
    fi
}
sent_toS3