Docker MISP Container
=====================
### Latest Update: 2-27-2019

Following the Official MISP Ubuntu 18.04 LTS build instructions.

Latest Upstream Change Included: a62bca4e169c919413bba4e6ce978e30aae9183e

Github repo + build script here:
https://github.com/harvard-itsecurity/docker-misp
(note: after a git pull, update ```build.sh``` with your own passwords/FQDN, and then build the image)

# What is this?
This is an easy and highly customizable Docker container with MISP -
Malware Information Sharing Platform & Threat Sharing (http://www.misp-project.org)

Our goal was to provide a way to setup + run MISP in less than a minute!

We follow the official MISP installation steps everywhere possible,
while adding automation around tedious manual steps and configurations.

We have done this without sacrificing options and the ability to
customize MISP for your unique environment! Some examples include:
auto changing the salt hash, auto initializing the database, auto generating GPG
keys, auto generating working + secure configs, and adding custom
passwords/domain names/email addresses/ssl certificates.

The misp-modules extensions functionality has been included and can be
accessed from http://[dockerhostip]:6666/modules.
(thanks to Conrad)

# Build Docker container vs using Dockerhub binary?

We always recommend building your own Docker MISP image using our "build.sh" script.
This allows you to change all the passwords and customize a few config options.

That said, you can pull down the Dockerhub binary image, but this is
_not_ supported or recommended. It's there purely for convenience, and so that you can "get
a feel" for MISP without building it. It will by default contain "LOCALHOST" as all configured host everywhere, and this will only work on the same system or if you proxy/port forward.


Building your own MISP Docker image is incredibly simple:
```
git clone https://github.com/harvard-itsecurity/docker-misp.git
cd docker-misp

# modify build.sh, specifically for:
# 1.) all passwords (MYSQL, GPG)
# 2.) change at LEAST "MISP_FQDN" to your FQDN (domain)

# Build the docker image - will take a bit, but it's a one time thing!
# Run this from the root of "docker-misp"
./build.sh
```

This will produce an image called: ```harvarditsecurity/docker-misp```

# How to run it in 3 steps:

About ```$docker-root``` - If you are running Docker on a Mac, there are some mount directory restrictions by default (see: https://docs.docker.com/docker-for-mac/osxfs/#namespaces). Your ```$docker-root``` needs to be either one of the supported defaults ("Users", "Volumes", "private", or "tmp"), otherwise, you must go to "Preferences" -> "File Sharing" and add your chosen $docker-root to the list.

We would suggest using ```/docker``` for your ```$docker-root```, and if using a Mac, adding that to the File Sharing list.

Once you have your DB directory created (```mkdir -p /docker/misp-db```), follow the 3 steps:

## 1. Initialize Database

```
docker run -it --rm \
    -v $docker-root/misp-db:/var/lib/mysql \
    harvarditsecurity/misp /init-db
```

## 2. Start the container
```
docker run -it -d \
    -p 443:443 \
    -p 80:80 \
    -p 3306:3306 \
    -v $docker-root/misp-db:/var/lib/mysql \
    harvarditsecurity/misp
```

## 3. Access Web URL
```
Go to: https://localhost (or your "MISP_FQDN" setting)

Login: admin@admin.test
Password: admin
```

And change the password! :)

# What can you customize/pass during build?
You can customize the ```build.sh``` script to pass custom:

* MYSQL_MISP_PASSWORD
* POSTFIX_RELAY_HOST
* MISP_FQDN
* MISP_EMAIL
* MISP_GPG_PASSWORD

See build.sh for an example on how to customize and build your own image with custom defaults.

# How to use custom SSL Certificates:
During run-time, override ```/etc/ssl/private```

```
docker run -it -d \
    -p 443:443 \
    -p 80:80 \
    -p 3306:3306 \
    -v $docker-root/certs:/etc/ssl/private \
    -v $docker-root/misp-db:/var/lib/mysql \
    harvarditsecurity/misp
```

And in your ```/certs``` dir, create private/public certs with file names:

* misp.key
* misp.crt

# Security note in regards to key generation:
We have added "rng-tools" in order to help with entropy generation,
since users have mentioned that during the pgp generation, some
systems have a hard time creating enough "randomness". This in turn
uses a pseudo-random generator, which is not 100% secure. If this is a
concern for a production environment, you can either 1.) take out the
"rng-tools" part from the Dockerfile and re-build the container, or
2.) replace the keys with your own! For most users, this should not
ever be an issue. The "rng-tools" is removed as part of the build
process after it has been used.

# Contributions:
Conrad Crampton: @radder5 - RNG Tools and MISP Modules

Jeremy Barlow: @jbarlow-mcafee - Cleanup, configs, conveniences, python 2 vs 3 compatibility

Matt Saunders: @matt-saunders - Fixed all install warnings and errors

Matija Čoklica: @XizzoR - Discovered problem where GPG key was empty

# Help/Questions/Comments:
For help or more info, feel free to contact Ventz Petkov: ventz_petkov@harvard.edu
