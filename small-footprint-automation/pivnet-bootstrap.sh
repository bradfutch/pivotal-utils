#!/bin/bash

#set -x

wget https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.55/pivnet-linux-amd64-0.0.55
chmod 0777 pivnet-linux-amd64-0.0.55
sudo mv pivnet-linux-amd64-0.0.55 /usr/local/bin/pivnet
pivnet login --api-token=$1

pivnet products
