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

rm -rf /etc/nginx
ln -sdf /data/nginx/main-conf /etc/nginx 
rm -rf /etc/nginx.custom.d
ln -sdf /data/nginx/http-conf /etc/nginx.custom.d 
rm -rf /etc/nginx.custom.global.d
ln -sdf /data/nginx/global-conf /etc/nginx.custom.global.d 
rm -rf /etc/ajenti
ln -sdf /data/ajenti /etc/ajenti 

echo $MYSQL_ADMIN_PASSWORD > /root/dbpass.txt

exec "$@"