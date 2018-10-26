#!/bin/bash

bosh create-env /home/ubuntu/bosh-1/bosh-deployment/bosh.yml \
    --state=/home/ubuntu/bosh-1/state.json \
    --vars-store=/home/ubuntu/bosh-1/creds.yml \
    -o /home/ubuntu/bosh-1/bosh-deployment/aws/cpi.yml \
    -v director_name=bosh-1 \
    -v internal_cidr=10.0.0.0/24 \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    -v access_key_id="${access_key_id}" \
    -v secret_access_key=${secret_access_key} \
    -v region="${region}" \
    -v instance_type=t2.medium \
    -v az="${region}a" \
    -v default_key_name="${default_key_name}" \
    -v default_security_groups=["${bosh_security_group}"] \
    -v private_key="/home/ubuntu/.ssh/${default_key_name}.pem" \
    -v subnet_id="${bosh_subnet}"
