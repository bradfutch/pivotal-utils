#!/bin/bash

username=${OM_USERNAME:-admin}
password=${OM_PASSWORD:-p1v0t4l}
target=$(terraform output -json | jq -r '.opsman_connect.value')

function doom() {
    om --username $username --password $password --skip-ssl-validation --target $target $*
}

doom $*
