#!/bin/bash

# executing previous entrypoint
/usr/local/bin/docker-entrypoint.sh

mkdir -p /data/db
chmod 0755 /data/db
chown -R mongod:mongod /data/db

exec "$@"