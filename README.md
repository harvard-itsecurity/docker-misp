Docker MISP Container
=====================
NOTE: Cannot autobuild on DockerHub due to size+time limit, and we
refuse to break this up into multiple images and chain them just to
get around the tiny resources that DockerHub provides!

Github repo + build script here:
https://github.com/harvard-itsecurity/docker-misp

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

# How to run it in 3 steps:

## 1. Initialize Database

```
docker run -it --rm \
    -v /misp-db:/var/lib/mysql \
    harvarditsecurity/misp /init-db
```

## 2. Start the container
```
docker run -it -d \
    -p 443:443 \
    -p 80:80 \
    -p 3306:3306 \
    -v /misp-db:/var/lib/mysql \
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

* MYSQL_ROOT_PASSWORD
* MYSQL_MISP_PASSWORD
* POSTFIX_RELAY_HOST
* MISP_FQDN
* MISP_EMAIL

See build.sh for an example on how to customize and build your own image with custom defaults.

# How to use custom SSL Certificates:
During run-time, override ```/etc/ssl/private```

```
docker run -it -d \
    -p 443:443 \
    -p 80:80 \
    -p 3306:3306 \
    -v /certs:/etc/ssl/private \
    -v /misp-db:/var/lib/mysql \
    harvarditsecurity/misp
```

And in your ```/certs``` dir, create private/public certs with file names:

* misp.key
* misp.cert

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
Conrad Crampton: conrad.crampton@secdata.com - @radder5 - RNG Tools and MISP Modules

# Help/Questions/Comments:
For help or more info, feel free to contact Ventz Petkov: ventz_petkov@harvard.edu
