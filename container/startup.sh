#!/usr/bin/env bash

if [ -f /init-db ]; then
   /init-db
fi

if [ -f /.misp_config_default/init-misp-config ]; then
   /.misp_config_default/init-misp-config
fi

if [ ! -f /etc/ssl/private/.ssl_initialized ] && [ ! -f /etc/ssl/private/misp.crt ] && [ ! -f /etc/ssl/private/misp.key ]; then
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout /etc/ssl/private/misp.key -out /etc/ssl/private/misp.crt -batch
    touch /etc/ssl/private/.ssl_initialized
fi

/usr/bin/supervisord -c "/etc/supervisor/conf.d/supervisord.conf"
