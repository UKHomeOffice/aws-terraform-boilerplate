#!/usr/bin/env bash

if [  $# -le 1 ]
then
	echo "Execute a terraform command."
	echo -e "\nUsage:\n$0 [env dir] [terraform command] <arguments...> \n"
	exit 1
fi

case $1 in
    local|dev|uat|stg|account-notprod)
        source ./common.sh notprod
    ;;
    prod|account-prod)
        source ./common.sh prod
    ;;
    *)
    echo "Unknown selection $1"
    ;;
esac

cd ../$1

case $1 in
    local|dev|uat|stg|prod)
        ../scripts/get-secret.sh $1 notify-key
    ;;
esac

shift
terraform $@