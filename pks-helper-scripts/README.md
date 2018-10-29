# PKS easy mode

This is a collection of scripts that should make using a toolsmiths deployed PKS installation super easy.  

# How to use these things?

Once your toolsmiths pipeline has completed you will receive an email titled : `GCP environment: <env_name> | Access & Return info`  In that email will be a link to a metadata file. Download that file first and move it into this directory. 

Now that you have your `<env_name>.json` in this diectory, Then you just need to edit the `pksrc` file to change the variable : 
```
TS_G_ENV=<your environment name>
```

Then the setup should be as simple as : 

```
source pksrc
./login.sh
```

What will happen is some environment variables will be set as well as a private key file will be generated for you called `<environment_name>.priv`.  This can be used to SSh into your OpsMan.  You will also have logged into your PKS api and targeted it for future `pks <commands>`.

That's it!  If you need to do any ops manager stuff there is a helper script here called `doom.sh`.  You can use that to issue any ops manager commands for you. Just makes that process easier.

# PKS Cluster deploy on GCP

When you decide to post a PKS cluster, you're going to need to provide a way to access it from the outside.  You do this by specifying an `--external-hostanme` flag to the `create-cluster` command.  This can be DNS or IP of a loadbalancer.  There is a GCP script under the `gcloud` directory that will make this easy for you.  

First in GCP you create a loadbalancer and do not specify any backend for it.  You can then use the IP that gets created as your `external-hostname` or make the additional step to create a DNS entry to reference it.  Now you're ready to deploy your cluster like so :

```
pks create-cluster <clustername> --external-hostname <ip of lb> --plan <small>
watch pks cluster <clustername>
```

You can then watch until the processing is complete.  Once the processing is complete you can use the helper script like so to automagically hookup your backend pool to the loadbalancer for your k8s master node.

```
gcloud/post-cluster.sh <clustername> <lbname>
```

This should go through the process of determining the instance information neccessary to add it to the loadbalancer target-pool.

# Also...

There is also an `ssh.sh` script that makes it super easy to SSH into your OpsMan as well.

Enjoy!
