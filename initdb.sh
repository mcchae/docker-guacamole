#!/usr/bin/env bash

docker exec guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
docker cp initdb.sql guacdb:/tmp/
docker exec guacdb sh -c 'mysql -u root --password=my12# guac < /tmp/initdb.sql'

# check with mysql
# docker exec -it guacdb mysql -u root --password=my12# guac
