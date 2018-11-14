#!/bin/bash

set -x
set -e

if [ -f ./keysrc ]; then
    echo "found rc file, sourcing..."
    echo
    source ./keysrc
fi

pivnet_token=${PIVNET_TOKEN:-fake}

auth="Authorization:Token $pivnet_token"
wget --header="$auth" $1
