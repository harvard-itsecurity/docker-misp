#!/bin/bash
docker rmi harvarditsecurity/misp
docker build \
    --rm=true --force-rm=true \
    --build-arg MYSQL_MISP_PASSWORD=ChangeThisDefaultPassworda9564ebc3289b7a14551baf8ad5ec60a \
    --build-arg POSTFIX_RELAY_HOST=localhost \
    --build-arg MISP_FQDN=localhost \
    --build-arg MISP_EMAIL=admin@localhost \
    --build-arg MISP_GPG_PASSWORD=ChangeThisDefaultPasswordXuJBao5Q2bps89LWFqWkKgDZwAFpNHvc \
    -t harvarditsecurity/misp container
