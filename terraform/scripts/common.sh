#!/bin/bash

R=`which jq 2>/dev/null`

if [  $? -ne 0 ]
then
	echo "Please install 'jq' binary"
	exit 1
fi

R=`which terraform 2>/dev/null`

if [  $? -ne 0 ]
then
	echo "Please install 'terraform' binary"
	exit 1
fi

R=`which aws 2>/dev/null`

if [  $? -ne 0 ]
then
	echo "Please install 'aws' binary"
	exit 1
fi
export AWS_PROFILE=$1