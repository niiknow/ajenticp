#!/bin/bash
# This script demonstrate install revive ads server on ajenti-udock/ajenti
# ask for domain name, install to /data/sites/domainname.com
# 

SITE_DOMAIN=adserver.yourdomain.com
read -e -p "Enter site domain name: " -i "adserver.yourdomain.com" SITE_DOMAIN

# install only if site does not exists
if [[ ! -d /data/sites/$SITE_DOMAIN ]]; then
	curl -i -o /tmp/revive-adserver-4.0.0.tar.gz https://download.revive-adserver.com/revive-adserver-4.0.0.tar.gz
	tar -zxvf /tmp/revive-adserver-4.0.0.tar.gz -C /opt/
	mv /opt/revive-adserver-4.0.0 /data/sites/$SITE_DOMAIN
	cd /data/sites/$SITE_DOMAIN
	chown -R www-data:www-data .
	find . -type d -exec chmod -R 775 {} \;
	find . -type f -exec chmod -R 664 {} \;
fi

