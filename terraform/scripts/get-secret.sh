#!/usr/bin/env bash

export KEY=$2

createlocal() {
    read value
    echo "locals {" > locals.tf
    echo "  $KEY = \"$value\"" >> locals.tf
    echo "}" >> locals.tf
}

aws secretsmanager get-secret-value --secret-id $1/$KEY --query SecretString --output text --profile $AWS_PROFILE | jq -r '.[env.KEY]' | createlocal

