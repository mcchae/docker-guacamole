#!/usr/bin/env bash

if [ ! -e /root/guacdb ];then
	mkdir /root/guacdb
fi
chown -R 999:999 /root/guacdb

docker-compose up -d
docker-compose logs -f
