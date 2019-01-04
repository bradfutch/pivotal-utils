#!/bin/bash

set -x

cluster_name=${1:-sandbox}
#note this could be automatic, but it's not
lb_name=${2:-first}

echo "configuring cluster $cluster_name for access ..."

master_vm_ips=($(pks cluster $cluster_name --json | jq -r '.kubernetes_master_ips | .[]'))


echo "$cluster_name master IPs found : "
printf "%s\n" "${master_vm_ips[@]}"

master_vm_names=()
for i in "${master_vm_ips[@]}"
do
   thing=$(gcloud compute instances list --format json | jq -r ".[] | select( .networkInterfaces | .[].networkIP == \"$i\") | .name")
   master_vm_names+=("$thing")
done

echo "master vm names..."
printf "%s\n" "${master_vm_names[@]}"

region=$(gcloud compute instances list --format json | jq -r ".[] | select( .networkInterfaces | .[].networkIP == \"${master_vm_ips[0]}\") | .zone" | rev | cut -d/ -f1 | rev | cut -d- -f1-2)

echo "region $region"

zone=$(gcloud compute instances list --format json | jq -r ".[] | select( .networkInterfaces | .[].networkIP == \"${master_vm_ips[0]}\") | .zone" | rev | cut -d/ -f1 | rev)

echo "zone $zone"

#gcloud compute target-instances create $cluster_name-target --instance=$master_vm_name --instance-zone=$zone
#echo "target-instance : $target_instance"

#NOTE this is all untested
echo "adding instance to load balancer..."

#gcloud compute forwarding-rules set-target first --target-instance=$cluster_name-target --target-instance-zone=$zone --region=$region

for name in "${master_vm_names[@]}"
do
    echo "adding master vm : $name"
    gcloud compute target-pools add-instances $lb_name --instances=$name --instances-zone=$zone --region=$region
done
