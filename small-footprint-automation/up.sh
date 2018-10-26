#!/bin/bash

#set -x
set -e

ops_man_version=2.2.6

if [ -f ./keysrc ]; then
    echo "found rc file, sourcing..."
    echo
    source ./keysrc
fi

pivnet_token=${PIVNET_TOKEN:-fake}
region=${AWS_REGION:-us-west-2}
az=${AWS_REGION:-us-west-2a}

echo "region :  $region"
echo "az :      $az"

ip=$(./whats-my-ip.sh)

replace_str="$ip/32"
echo "ip :      $replace_str"

ops_man_releases_page=$(http https://network.pivotal.io/api/v2/products | jq -r '.products | .[] | select( .slug == "ops-manager" ) | ._links.releases.href')

ops_man_product_files_page=$(http $ops_man_releases_page | jq -r '.releases | .[] | select( .version == "2.2.6") | ._links.product_files.href')

ops_man_ami_ymls=$(http $ops_man_product_files_page | jq -r '.product_files | .[] | select( .aws_object_key | contains("onAWS.yml")) | ._links.download.href')

echo "yml href: $ops_man_ami_ymls"

auth="Authorization:Token $pivnet_token" 
query=".[\"$region\"]"
ops_man_ami=$(http --follow $ops_man_ami_ymls "$auth" | yq -r $query)
echo "ami:      $ops_man_ami"


# in place replace things in the terraform.tfvars file

sed -i "" "\#^yourip#s#\".*\"#\"$replace_str\"#g" terraform.tfvars
sed -i "" "/^opsman_ami/s/\".*\"/\"$ops_man_ami\"/g" terraform.tfvars
sed -i "" "/^az/s/\".*\"/\"$az\"/g" terraform.tfvars
sed -i "" "/^access_key_id/s/\".*\"/\"$AWS_ACCESS_KEY_ID\"/g" terraform.tfvars
sed -i "" "\#^secret_access_key#s#\".*\"#\"$AWS_SECRET_ACCESS_KEY\"#g" terraform.tfvars

terraform init
terraform plan -out=plan
sleep 3
terraform apply plan
