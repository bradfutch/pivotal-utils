#!/bin/bash

set -x

username=$(cat ${TS_G_ENV}.json | jq -r '.ops_manager.username')
password=$(cat ${TS_G_ENV}.json | jq -r '.ops_manager.password')
target=$(cat ${TS_G_ENV}.json | jq -r '.ops_manager.url')

function doom() {
    om --username $username --password $password --skip-ssl-validation --target $target $*
}

doom $*
