#!/bin/bash

set -x

cluster_name=${1:-sandbox}
#note this could be automatic, but it's not
lb_name=first

echo "configuring cluster $cluster_name for access ..."

master_vm_ip=$(pks cluster $cluster_name --json | jq -r '.kubernetes_master_ips | .[0]')

echo "$cluster_name master IP found : $master_vm_ip"

master_vm_name=$(gcloud compute instances list --format json | jq -r ".[] | select( .networkInterfaces | .[].networkIP == \"$master_vm_ip\") | .name")

echo "found master vm name $master_vm_name"

region=$(gcloud compute instances list --format json | jq -r ".[] | select( .networkInterfaces | .[].networkIP == \"10.0.11.10\") | .zone" | rev | cut -d/ -f1 | rev | cut -d- -f1-2)

echo "region $region"

zone=$(gcloud compute instances list --format json | jq -r ".[] | select( .networkInterfaces | .[].networkIP == \"10.0.11.10\") | .zone" | rev | cut -d/ -f1 | rev)

echo "zone $zone"

#gcloud compute target-instances create $cluster_name-target --instance=$master_vm_name --instance-zone=$zone
#echo "target-instance : $target_instance"

#NOTE this is all untested
echo "adding instance to load balancer..."

#gcloud compute forwarding-rules set-target first --target-instance=$cluster_name-target --target-instance-zone=$zone --region=$region

gcloud compute target-pools add-instances first --instances=$master_vm_name --instances-zone=$zone --region=$region
