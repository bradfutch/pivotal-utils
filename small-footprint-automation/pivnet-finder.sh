#!/bin/bash

set -x
set -e

if [ -f ./keysrc ]; then
    echo "found rc file, sourcing..."
    echo
    source ./keysrc
fi

product=${1:-ops-manager}
pivnet_token=${PIVNET_TOKEN:-fake}

release_page=$(http https://network.pivotal.io/api/v2/products | jq -r ".products | .[] | select( .slug == \"$product\" ) | ._links.releases.href")

product_files_page=$(http $release_page | jq -r '.releases | .[0] | ._links.product_files.href')

tile_file=$(http $product_files_page | jq -r '.product_files | .[] | select( .aws_object_key | contains(".pivotal")) | ._links.download.href')

echo "yml href: $tile_file"

auth="Authorization:Token $pivnet_token" 
wget -O $product.pivotal --header="$auth" $tile_file 
