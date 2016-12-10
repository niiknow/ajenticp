#!/bin/bash
mkdir -p /data/ajenti
mkdir -p /data/cron
mkdir -p /data/backup.d
mkdir -p /data/nginx/sites-conf
mkdir -p /data/mysql
mkdir -p /data/mysqldump
mkdir -p /data/php/5.6/fpm/pool.d
mkdir -p /data/php/7.0/fpm/pool.d
mkdir -p /data/php/7.1/fpm/pool.d
mkdir -p /data/redis/db
mkdir -p /data/sites
mkdir -p /data/supervisor/supervisor.d

# handle ajenti
mv -n /etc/ajenti/** /data/ajenti
rm -rf /etc/ajenti
ln -sdf /data/ajenti /etc/ajenti 

# setup custom cron
rm -f /etc/cron.d/ajenticron
ln -sf /data/ajenti/ajenticron /etc/cron.d/ajenticron

# handle nginx
if [[ ! -d /etc/nginx/backup ]]; then
    mv -n /etc/nginx /data/nginx/backup
fi
rm -rf /etc/nginx || true
ln -sdf /data/nginx /etc/nginx

# handle backup.d
mv -n /etc/backup.d/** /data/backup.d
rm -rf /etc/backup.d
ln -sdf /data/backup.d /etc/backup.d

# handle redis
mv -n /etc/redis/** /data/redis
rm -rf /etc/redis
ln -sdf /data/redis /etc/redis

# handle backupninja
mv -n /etc/backup.d/** /data/backup.d
rm -rf /etc/backup.d
ln -sdf /data/backup.d /etc/backup.d

# handle supervisor
mv -n /etc/supervisor/conf.d/** /data/supervisor/conf.d
rm -rf /data/supervisor/conf.d
ln -sdf /data/supervisor/conf.d /etc/supervisor/conf.d

# handle all php conf
mv -n /etc/php/5.6/fpm/pool.d/*.conf /data/php/5.6/fpm/pool.d
mv -n /etc/php/7.0/fpm/pool.d/*.conf /data/php/7.0/fpm/pool.d
mv -n /etc/php/7.1/fpm/pool.d/*.conf /data/php/7.1/fpm/pool.d

# update data permission
chown -R www-data:www-data /data/sites
find /data/sites -type d -exec chmod -R 775 {} \;
find /data/sites -type f -exec chmod -R 664 {} \;
chown -R redis:redis /data/redis/db

# handle crontab
mv -n /var/spool/cron/** /data/cron
rm -rf /var/spool/cron
ln -sdf /data/cron /var/spool/cron

# load php before supervisor start
service cron start
service php5.6-fpm start
service php7.0-fpm start
service php7.1-fpm start

# make sure supervisor service is running
service supervisor start

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

# initialize mysql for the first time if required
VOLUME_HOME="/data/mysql"
export TERM=linux
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME" 1>&2
    echo "=> Installing MySQL ..." 1>&2
    mysql_install_db --user=mysql

    # echo "GRANT ALL PRIVILEGES ON *.* TO 'ajenti'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql
    killall mysqld

    # wait for mysql to stop before updating volume permission
    echo "=> Waiting for mysqld to be ready ..." 1>&2
    sleep 10s
    chown -R mysql:mysql "$VOLUME_HOME"
fi

# start mysql and then ajenti
service mysql start
service ajenti start

# run child entrypoint
if [ -f /usr/local/bin/docker-entrypoint-child.sh ];  then
    /usr/local/bin/docker-entrypoint-child.sh
fi

exec "$@"