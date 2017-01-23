#!/bin/sh
# restore current users
if [[ -f /ajenti/etc-bak/passwd ]]; then
	# restore users
	rsync -a /ajenti/etc-bak/passwd /etc/passwd
	rsync -a /ajenti/etc-bak/shadow /etc/shadow
	rsync -a /ajenti/etc-bak/gshadow /etc/gshadow
	rsync -a /ajenti/etc-bak/group /etc/group
fi

# only if you run in privileged mode
# if [[ -f /etc/fail2ban/jail.new ]]; then
#     mv /etc/fail2ban/jail.local /etc/fail2ban/jail.local-bak
#     mv /etc/fail2ban/jail.new /etc/fail2ban/jail.local
# fi

# install phpMyAdmin if not exists
if [[ ! -d /ajenti/sites/phpMyAdmin ]]; then
    curl -s -o /tmp/phpMyAdmin.tar.gz https://files.phpmyadmin.net/phpMyAdmin/4.6.5.2/phpMyAdmin-4.6.5.2-all-languages.tar.gz
    tar -zxf /tmp/phpMyAdmin.tar.gz -C /ajenti/sites/
    $blowfish = $(pwgen -s 80 -1 -v -c -0)
    cp /sysprepz/sites/config.inc.php /ajenti/sites/phpMyAdmin/config.inc.php
    sed -i -e "s/BLOWFISH_SECRET/$blowfish/g" /ajenti/sites/phpMyAdmin/config.inc.php
    chown -R www-data:www-data /ajenti/sites
fi

# required startup and of course ajenti
cd /etc/init.d/

./disable-transparent-hugepages defaults
./ssh start
./ajenti start

./php5.6-fpm start
./php7.0-fpm start
./php7.1-fpm start
./nginx start
