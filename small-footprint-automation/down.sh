#!/bin/bash

set -e

terraform destroy -auto-approve

unset BOSH_CLIENT
unset BOSH_GW_HOST
unset BOSH_GW_PRIVATE_KEY
unset BOSH_GW_USER
unset BOSH_ENVIRONMENT
unset BOSH_CLIENT_SECRET
unset BOSH_DEPLOYMENT
unset BOSH_CA_CERT

rm terraform.tfstate
rm terraform.tfstate.backup
rm plan
