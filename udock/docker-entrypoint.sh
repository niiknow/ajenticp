#!/bin/bash
mkdir -p /data/ajenti
mkdir -p /data/mysql
mkdir -p /data/backups
mkdir -p /data/sites
chown -R www-data:www-data /data/sites

mkdir -p /data/nginx/http-conf
mkdir -p /data/nginx/global-conf
mkdir -p /data/nginx/main-conf

mv -n /etc/nginx/** /data/nginx/main-conf
mv -n /etc/ajenti/** /data/ajenti

rm /etc/nginx
ln -sf /etc/nginx /data/nginx/main-conf
rm /etc/nginx.custom.d
ln -sf /etc/nginx.custom.d /data/nginx/http-conf
rm /etc/nginx.custom.global.d
ln -sf /etc/nginx.custom.global.d /data/nginx/global-conf
rm /etc/ajenti
ln -sf /etc/ajenti /data/ajenti

echo $MYSQL_ADMIN_PASSWORD > /root/dbpass.txt

exec "$@"