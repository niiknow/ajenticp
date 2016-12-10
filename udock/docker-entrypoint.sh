#!/bin/bash
mkdir -p /data/ajenti
mkdir -p /data/mysqldump
mkdir -p /data/mysql
mkdir -p /data/sites
mkdir -p /data/nginx/sites-conf
mkdir -p /data/redis/db
mkdir -p /data/php/5.6/fpm/pool.d
mkdir -p /data/php/7.0/fpm/pool.d
mkdir -p /data/php/7.1/fpm/pool.d
chown -R www-data:www-data /data/sites

mv -n /etc/ajenti/** /data/ajenti
rm -rf /etc/ajenti
ln -sdf /data/ajenti /etc/ajenti 

rm -rf /etc/nginx
ln -sdf /data/nginx /etc/nginx

mv -n /etc/redis/** /data/redis
mv -n /etc/php/5.6/fpm/pool.d/*.conf /data/php/5.6/fpm/pool.d
mv -n /etc/php/7.0/fpm/pool.d/*.conf /data/php/7.0/fpm/pool.d
mv -n /etc/php/7.1/fpm/pool.d/*.conf /data/php/7.1/fpm/pool.d

# load php before supervisor start
service php5.6-fpm start
service php7.0-fpm start
service php7.1-fpm start

# echo "GRANT ALL PRIVILEGES ON *.* TO 'ajenti'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql

# make sure supervisor service is running
# so it start ajenti
service supervisor start
service ajenti start

# install phpMyAdmin if not exists
if [[ ! -d /data/sites/phpMyAdmin ]]; then
    echo "installing phpMyAdmin" 1>&2
    curl -s -o /tmp/phpMyAdmin-4.6.5.2-all-languages.tar.gz https://files.phpmyadmin.net/phpMyAdmin/4.6.5.2/phpMyAdmin-4.6.5.2-all-languages.tar.gz
    tar -zxvf /tmp/phpMyAdmin-4.6.5.2-all-languages.tar.gz -C /opt/
    mv /opt/phpMyAdmin-4.6.5.2-all-languages /data/sites/phpMyAdmin
    $blowfish = $(pwgen -s 80 -1 -v -c -0)
    cp /tmp/config.inc.php /data/sites/phpMyAdmin/config.inc.php
    sed -i -e "s/BLOWFISH_SECRET/$blowfish/g" /data/sites/phpMyAdmin/config.inc.php
fi

chown -R mysql:mysql "$VOLUME_HOME"

chown -R www-data:www-data /data/sites
find /data/sites -type d -exec chmod -R 775 {} \;
find /data/sites -type f -exec chmod -R 664 {} \;

# start mysql
service mysql start

exec "$@"