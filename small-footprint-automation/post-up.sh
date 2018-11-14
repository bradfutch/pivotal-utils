#!/bin/bash

set -e

if [ -f ./keysrc ]; then
    echo "found rc file, sourcing..."
    echo
    source ./keysrc
fi

username=${OM_USERNAME:-admin}
password=${OM_PASSWORD:-p1v0t4l}
target=$(terraform output -json | jq -r '.opsman_connect.value')

function doom() {
    om --username $username --password $password --skip-ssl-validation --target $target $*
}

function doBosh() {

    # Fish out values form the terraform output

    vpc_id=$(terraform output -json | jq -r '.vpc_id.value')
    secgrp=$(terraform output -json | jq -r '.bosh_security_group.value')
    public_subnet_id=$(terraform output -json | jq -r '.public_subnet.value')
    pas_subnet_id=$(terraform output -json | jq -r '.pas_subnet.value')
    mgmt_subnet_id=$(terraform output -json | jq -r '.management_subnet.value')

    # configure the ops manager to use internal authentication

    om --skip-ssl-validation --target $target configure-authentication \
    --decryption-passphrase $password$password$password \
    --username $username \
    --password $password 

    # replace the director-config values with the dynamically generated ones from the AWS environment we 
    # just stood up.

    sed -i "" "/^access_key_id/s/\".*\"/\"$AWS_ACCESS_KEY_ID\"/g" director-config.yml
    sed -i "" "\#^secret_access_key#s#\".*\"#\"$AWS_SECRET_ACCESS_KEY\"#g" director-config.yml

    sed -i "" "/vpc_id/s/:.*/: $vpc_id/g" director-config.yml
    sed -i "" "/security_group/s/:.*/: $secgrp/g" director-config.yml
    gsed -i "/^\s*- name: opsman-network/{n;n;/.*iaas_identifier/s/:.*/: $public_subnet_id/g}" director-config.yml
    gsed -i "/^\s*- name: pcf-pas-subnet/{n;n;/.*iaas_identifier/s/:.*/: $pas_subnet_id/g}" director-config.yml
    gsed -i "/^\s*- name: pcf-management-subnet/{n;n;/.*iaas_identifier/s/:.*/: $mgmt_subnet_id/g}" director-config.yml
    # configure the bosh tile

    doom configure-director --config director-config.yml

    # apply the bosh tile

    doom apply-changes

    # get the credentials

    doom curl -s --path /api/v0/deployed/director/credentials/bosh_commandline_credentials > tmp_creds.json
    cat tmp_creds.json | jq -r .credential | xargs -n1 -I{} echo "export {}" >> boshrc
    rm tmp_creds.json

}

function doUpload() {
    dir=$(pwd)
    file=srt-2.1.12-build.1.pivotal
    doom upload-product --product ./$file
}

function doStage() {
    name=cf
    version=2.1.12

    doom stage-product -p $name -v $version
}


doBosh
doUpload
doStage
