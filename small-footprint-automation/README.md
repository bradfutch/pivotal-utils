# Small Terraform Deployment

This repo uses terraform to deploy a VPC, security groups, jumpbox, and Ops Manager to your EC2 environment.  
This is just a time saver to stand up the necessary components to start a PCF/PKS deployment.  The nice thing about this 
method is that there is no opacity to it.  All of the steps should be clear and transparent.  The only moving parts are 
the 2 scripts `up.sh` and `down.sh` which do what they say on the tin.

# Config

There are a few things that have to be done manually currently.  The first is that you need a key created up in amazon that will be used for 
accessing vms that are spun up.  This named key then is used below in your `terraform.tfvars`. The other item is that you will need to create 
a set of certs for your environment.  These will be used to spin up your environment for SSL.  This can be done using a project like 
certbot (https://certbot.eff.org/).  

You also need to download from PivNet the PAS Small footprint tile and have the file local to this directory.  It should be named `srt-2.1.12-build.1.pivotal`.

You need to provide a `terraform.tfvars` file, and some sort of rc file for setting environment variables. You will also 
need to have a ssh key created in AWS ahead of time and have access to the private key and the name.

`keysrc` : 

```
export AWS_ACCESS_KEY_ID="AMAZON KEY HERE - STARTS WITH AK"
export AWS_SECRET_ACCESS_KEY="AMAZON SECRET HERE"
export PIVNET_TOKEN="PIVNET TOKEN HERE"
```

`terraform.tfvars` : 

```
yourip              = "THIS WILL BE DYNAMICALLY DETERMINED BY THE SCRIPT"
opsman_ami          = "DYNAMIC"
access_key_id       = "DYNAMIC"
secret_access_key   = "DYNAMIC"
region              = "us-west-2"
az                  = "us-west-2a"
default_key_name    = "pcf"
private_key = <<SSL_CERT
YOUR CERT GOES HERE
SSL_CERT
```

# Install

Once you've set all of the necessary config, then the install process should be as simple as :

```
source keysrc
./up.sh
```

You can now watch as the script finds the necessary dynamic information and then uses terraform to bring up your environment.  By the end of the 
script you should now have a jumpbox and an OpsMan waiting to be configured.


Now you're ready to configure the OpsMan for local auth and upload and stage the PAS Small footprint tile.  This is all handled by the script `post-up.sh`  To do the uplaod
and staging you simply need to run the following command : 

```
./post-up.sh
```

If you'd like to run any more OM commands you can do so using the little helper script called `doom.sh`  You can simply invoke it like so :

```
./doom.sh <arguments for OM here>
```

# Destroy

To tear down the environment you simply run : 

```
./down.sh
```
