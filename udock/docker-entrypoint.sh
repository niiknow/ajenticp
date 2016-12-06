#!/bin/bash
mkdir -p /data/ajenti
mkdir -p /data/backups
mkdir -p /data/sites
chown -R www-data:www-data /data/sites

mkdir -p /data/nginx/http-conf
mkdir -p /data/nginx/global-conf
# mkdir -p /data/nginx/main-conf

# mv -n /etc/nginx/** /data/nginx/main-conf
mv -n /etc/ajenti/** /data/ajenti

# rm -rf /etc/nginx
# ln -sdf /data/nginx/main-conf /etc/nginx 
rm -rf /etc/nginx.custom.d
ln -sdf /data/nginx/http-conf /etc/nginx.custom.d 
rm -rf /etc/nginx.custom.global.d
ln -sdf /data/nginx/global-conf /etc/nginx.custom.global.d 
rm -rf /etc/ajenti
ln -sdf /data/ajenti /etc/ajenti 

echo $MYSQL_ADMIN_PASSWORD > /root/dbpass.txt

VOLUME_HOME="/var/lib/mysql"
export TERM=linux
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db --user=mysql

    echo "=> Reconfiguring MySQL ..."
    TERM=linux dpkg-reconfigure mysql-server
    PASSWD="$(grep -m 1 --only-matching --perl-regex "(?<=password \= ).*" /etc/mysql/debian.cnf)"
    /usr/bin/mysqld_safe &
    sleep 5s
    echo "=>executing   GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY '$PASSWD';"
    echo "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY '$PASSWD';" | mysql

    /usr/bin/mysqladmin -u root password $MYSQL_ADMIN_PASSWORD
    
    killall mysqld    
    sleep 5s
    
    echo "=> Done!"  
else
    echo "=> Using an existing volume of MySQL"
    echo "=> Updating root and admin passwords"
    PASSWD="$(grep -m 1 --only-matching --perl-regex "(?<=password \= ).*" /etc/mysql/debian.cnf)"

    /usr/bin/mysqld_safe &
    sleep 5s

    /usr/bin/mysqladmin -u root password $MYSQL_ADMIN_PASSWORD
    
    echo "SET PASSWORD FOR 'admin'@'localhost' = PASSWORD('$PASSWD');" |mysql -u root --password=$MYSQL_ADMIN_PASSWORD

    killall mysqld    
    sleep 5s
fi

service php5.6-fpm restart
service php7.0-fpm restart

exec "$@"