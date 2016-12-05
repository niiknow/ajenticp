#!/bin/bash
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
    echo "=>executing   GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '$PASSWD';"
    echo "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '$PASSWD';" | mysql

    /usr/bin/mysqladmin -u root password $MYSQL_ADMIN_PASSWORD
    
    killall mysqld    
    sleep 5s
    
    echo "=> Done!"  
else
    echo "=> Using an existing volume of MySQL"
    echo "=> Updating root and debian-sys-maint passwords"
    PASSWD="$(grep -m 1 --only-matching --perl-regex "(?<=password \= ).*" /etc/mysql/debian.cnf)"

    /usr/bin/mysqld_safe &
    sleep 5s

    /usr/bin/mysqladmin -u root password $MYSQL_ADMIN_PASSWORD
    
    echo "SET PASSWORD FOR 'debian-sys-maint'@'localhost' = PASSWORD('$PASSWD');" |mysql -u root --password=$MYSQL_ADMIN_PASSWORD

    killall mysqld    
    sleep 5s
fi

mkdir -p /data/sites
mkdir -p /data/backups
chown -R www-data:www-data /data/sites

echo $MYSQL_ADMIN_PASSWORD > /root/dbpass.txt
systemctl enable ajenti
service ajenti restart

exec "$@"