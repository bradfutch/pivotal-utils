# PKS easy mode

This is a collection of scripts that should make using a toolsmiths deployed PKS installation super easy.  This basically takes the downloaded metadata file from the email that the team sends you.

# How to use these things?

Basically you should have to move the JSON file that you download into this directory.  It will have a random environment name.  Then you just need to edit the `pksrc` file to change the variable : 
```
TS_G_ENV=<your environment name>
```

Then the setup should be as simple as : 

```
source pksrc
./login.sh
```

What will happen is some environment variables will be set as well as a private key fil will be generated for you called `<environment_name>.priv`.  This can be used to SSh into your OpsMan.  You will also have logged into your PKS api and targeted it for future `pks <commands>`.

That's it!  If you need to do any ops manager stuff there is a helper script here called `doom.sh`.  You can use that to issue any ops manager commands for you. Just makes that process easier.

There is also an `ssh.sh` script that makes it super easy to SSH into your OpsMan as well.

Enjoy!
