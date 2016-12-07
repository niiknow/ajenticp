#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get -o Acquire::GzipIndexes=false update

echo "1. apt updating for the first time" 1>&2
apt-get update && apt-get -yq upgrade 
apt-get install -yqf wget apt-show-versions apt-utils software-properties-common build-essential  \
	python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev \
	sudo git curl nano vim mariadb-server mariadb-client libmagickwand-dev imagemagick \
	php-dev php-pear mcrypt pwgen backupninja duplicity tcl redis-server

pecl install imagick 

echo "2. applying Xenial specific fixes before apt update" 1>&2
wget http://repo.ajenti.org/debian/key -O- | apt-key add -
echo "deb http://repo.ajenti.org/debian main main ubuntu" > /etc/apt/sources.list.d/ajenti.list
apt-add-repository -y ppa:ondrej/php
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C

echo "3. configure and force update all: resolve apt-utils and apt-show-versions issues" 1>&2
dpkg --configure -a
apt-get update && apt-get -yq upgrade && apt-get install -yf

# echo "4. adding php / nodejs / backupninja / duplicity" 1>&2
# apt-get install -y software-properties-common
#apt-get update && apt-get install -yq sudo git curl nano vim mariadb-server mariadb-client libmagickwand-dev imagemagick php-dev php-pear backupninja duplicity

#echo "5. install basic python for python-support_1.0.15_all.deb" 1>&2
#apt-get install -yq build-essential python-pip python-dev python-lxml libffi-dev libssl-dev libjpeg-dev libpng-dev uuid-dev python-dbus python-augeas python-apt 

echo "4. installing python support" 1>&2
curl -s -o /tmp/python-support_1.0.15_all.deb https://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb
dpkg -i /tmp/python-support_1.0.15_all.deb

echo "5. installing ajenti" 1>&2
apt-get install -yq ajenti php-all-dev pkg-php-tools
apt-get install -yq ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php5.6-fpm ajenti-v-php7.0-fpm ajenti-v-mail ajenti-v-nodejs ajenti-v-python-gunicorn ajenti-v-ruby-unicorn 
# apt-get install -yq php5.6-fpm php5.6-mysql php5.6-cli php5.6-readline php5.6-mbstring php5.6-zip php5.6-intl php5.6-xml php5.6-json php5.6-curl php5.6-mcrypt php5.6-gd php5.6-pgsql php5.6-mongodb php5.6-pspell php5.6-sqlite php5.6-zip  
# apt-get install -yq php7.0-fpm php7.0-mysql php7.0-cli php7.0-readline php7.0-mbstring php7.0-zip php7.0-intl php7.0-xml php7.0-json php7.0-curl php7.0-mcrypt php7.0-gd php7.0-pgsql php7.0-mongodb php7.0-pspell php7.0-sqlite php7.0-zip
# apt-get install -yq mcrypt php-apc php-apcu php-imagick
apt-get install -yq php5.6-fpm php5.6-cgi php5.6-cli php5.6-dev php5.6-geoip php5.6-common \
	php5.6-curl php5.6-enchant php5.6-gd php5.6-imap php5.6-mysql php5.6-mysqlnd php5.6-pspell php5.6-sqlite3 \
	php5.6-tidy php5.6-opcache php5.6-json php5.6-bz2 php5.6-mcrypt php5.6-readline php5.6-xmlrpc \
	php5.6-intl php5.6-xml php5.6-xsl php5.6-ldap php5.6-imagick php5.6-pgsql php5.6-redis

apt-get install -yq php7.0-fpm php7.0-cgi php7.0-cli php7.0-dev php7.0-geoip php7.0-common \
	php7.0-curl php7.0-enchant php7.0-gd php7.0-imap php7.0-mysql php7.0-mysqlnd php7.0-pspell php7.0-sqlite3 \
	php7.0-tidy php7.0-opcache php7.0-json php7.0-bz2 php7.0-mcrypt php7.0-readline php7.0-xmlrpc \
	php7.0-intl php7.0-xml php7.0-xsl php7.0-ldap php7.0-imagick php7.0-pgsql php7.0-redis

# install composer
curl -sS https://getcomposer.org/installer | php -- --version=1.2.1 --install-dir=/usr/local/bin --filename=composer

# only install node if not exists, maybe you already have node from a different source
if ! type "nodejs -v" > /dev/null; then
  apt-get install -yq nodejs npm
  ln -sf /usr/bin/nodejs /bin/node 
fi

echo "6. installing phpMyAdmin" 1>&2
curl -s -o /tmp/phpMyAdmin-4.6.5.1-all-languages.tar.gz https://files.phpmyadmin.net/phpMyAdmin/4.6.5.1/phpMyAdmin-4.6.5.1-all-languages.tar.gz
tar -zxvf /tmp/phpMyAdmin-4.6.5.1-all-languages.tar.gz -C /opt/
mv /opt/phpMyAdmin-4.6.5.1-all-languages /opt/phpMyAdmin

echo "7. making changes to ajenti" 1>&2
rm -f /var/lib/ajenti/plugins/vh/api.pyc
sed -i -e "s/\/srv\/new\-website/\/ajenti\/sites\/new\-website/g" /var/lib/ajenti/plugins/vh/api.py
sed -i -e "s/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/g" /etc/php5.6/fpm/php.ini

