#!/bin/bash

sudo apt-get install -y software-properties-common

sudo add-apt-repository -y ppa:brightbox/ruby-ng

sudo apt-get update -y

sudo apt-get install -y ruby2.4

sudo -get upgrade -y

sudo apt-get install -y build-essential zlibc zlib1g-dev ruby \
ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 \
libreadline6-dev libyaml-dev libsqlite3-dev sqlite3

curl -Lo ./bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-5.0.1-linux-amd64

chmod +x ./bosh

sudo mv ./bosh /usr/local/bin/bosh

mkdir bosh-1 && cd bosh-1

git clone https://github.com/cloudfoundry/bosh-deployment

sudo chown -R ubuntu:ubuntu /home/ubuntu/bosh-1
