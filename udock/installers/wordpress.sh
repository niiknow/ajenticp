#!/bin/bash
# This script demonstrate install wordpress on ajenti-udock/ajenti
# ask for domain name, install to /srv/domainname.com
# 

SITE_DOMAIN=yourblog.com
read -e -p "Enter site domain name: " -i "yourblog.com" SITE_DOMAIN

# Install WP-CLI
if [ ! -f /usr/local/bin/wp ];  then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
fi

mkdir -p /srv/$SITE_DOMAIN
cd /srv/$SITE_DOMAIN
DBNAME=${SITE_DOMAIN//[^a-zA-Z09]/_} 
wp --allow-root core download
wp --allow-root core config --dbhost=localhost --dbname=$DBNAME --dbuser=root --dbpass=$MYSQL_ADMIN_PASSWORD
chown -R www-data:www-data .
chmod 644 wp-config.php

