#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse" > /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" >> /etc/apt/sources.list

export DEBIAN_FRONTEND=noninteractive
apt-get -o Acquire::GzipIndexes=false update

echo "1. apt updating for the first time" 1>&2
apt-get update && apt-get -yq upgrade && apt-get install -yqf locale-gen wget git curl nano apt-show-versions apt-utils

echo "2. applying Xenial specific fixes before apt update" 1>&2
wget http://repo.ajenti.org/debian/key -O- | apt-key add -
echo "deb http://repo.ajenti.org/debian main main ubuntu" > /etc/apt/sources.list.d/ajenti.list

echo "3. configure and force update all: resolve apt-utils and apt-show-versions issues" 1>&2
locale-gen "en_US.UTF-8"
dpkg-reconfigure locales
dpkg --configure -a
apt-get update && apt-get -yq full-upgrade && apt-get install -yf

echo "4. adding php / nodejs / memcached / backupninja / duplicity" 1>&2
apt-get install -y software-properties-common
apt-add-repository -y ppa:ondrej/php
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
apt-get update
apt-get install -yq php5.6-fpm php5.6-mysql 
apt-get install -yq php7.0-fpm php7.0-mysql memcached backupninja duplicity

# only install node if not exists, maybe you already have node from a different source
if ! type "node -v" > /dev/null; then
  apt-get install -yq nodejs npm
fi

echo "5. install basic python for python-support_1.0.15_all.deb" 1>&2
apt-get install -yq build-essential python-pip python-dev python-lxml libffi-dev libssl-dev libjpeg-dev libpng-dev uuid-dev python-dbus python-augeas python-apt 

echo "6. installing python support" 1>&2
wget http://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb
dpkg -i python-support_1.0.15_all.deb

echo "7. installing ajenti" 1>&2
apt-get install -yq ajenti
apt-get install -yq ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php5.6-fpm ajenti-v-php7.0-fpm ajenti-v-mail ajenti-v-nodejs ajenti-v-python-gunicorn ajenti-v-ruby-unicorn 

echo "8. installing phpMyAdmin" 1>&2
wget https://files.phpmyadmin.net/phpMyAdmin/4.6.5.1/phpMyAdmin-4.6.5.1-all-languages.tar.gz
tar -zxvf phpMyAdmin-4.6.5.1-all-languages.tar.gz -C /opt/
mv /opt/phpMyAdmin-4.6.5.1-all-languages /opt/phpMyAdmin
