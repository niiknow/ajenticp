FROM niiknow/docker-hostingbase:0.5.12

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive

# start
RUN \
    cd /tmp \
    && apt-get -o Acquire::GzipIndexes=false update \
    && wget http://repo.ajenti.org/debian/key -O- | apt-key add - \
    && echo "deb http://repo.ajenti.org/debian main main ubuntu" > /etc/apt/sources.list.d/ajenti.list \

    && apt-get update && apt-get upgrade -y \
    && apt-get install -y mariadb-server mariadb-client redis-server fail2ban \
    && dpkg --configure -a

RUN \
    cd /tmp \
    && apt-get install -yq ajenti php-all-dev pkg-php-tools \
    && apt-get install -yq ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php5.6-fpm \
        ajenti-v-php7.0-fpm ajenti-v-mail ajenti-v-nodejs ajenti-v-python-gunicorn ajenti-v-ruby-unicorn 

RUN \
    cd /tmp \

# awscli
    && curl -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install awscli \

# pymongo
    && pip install pymongo \

    && apt-get install -yq php5.6-fpm php5.6-mbstring php5.6-cgi php5.6-cli php5.6-dev php5.6-geoip php5.6-common php5.6-xmlrpc \
        php5.6-curl php5.6-enchant php5.6-imap php5.6-xsl php5.6-mysql php5.6-mysqlnd php5.6-pspell php5.6-gd \
        php5.6-tidy php5.6-opcache php5.6-json php5.6-bz2 php5.6-pgsql php5.6-mcrypt php5.6-readline  \
        php5.6-intl php5.6-sqlite3 php5.6-ldap php5.6-xml php5.6-redis php5.6-imagick php5.6-zip \

    && apt-get install -yq php7.0-fpm php7.0-mbstring php7.0-cgi php7.0-cli php7.0-dev php7.0-geoip php7.0-common php7.0-xmlrpc \
        php7.0-curl php7.0-enchant php7.0-imap php7.0-xsl php7.0-mysql php7.0-mysqlnd php7.0-pspell php7.0-gd \
        php7.0-tidy php7.0-opcache php7.0-json php7.0-bz2 php7.0-pgsql php7.0-mcrypt php7.0-readline  \
        php7.0-intl php7.0-sqlite3 php7.0-ldap php7.0-xml php7.0-redis php7.0-imagick php7.0-zip \

    && apt-get install -yq php7.1-fpm php7.1-mbstring php7.1-cgi php7.1-cli php7.1-dev php7.1-geoip php7.1-common php7.1-xmlrpc \
        php7.1-curl php7.1-enchant php7.1-imap php7.1-xsl php7.1-mysql php7.1-mysqlnd php7.1-pspell php7.1-gd \
        php7.1-tidy php7.1-opcache php7.1-json php7.1-bz2 php7.1-pgsql php7.1-mcrypt php7.1-readline \
        php7.1-intl php7.1-sqlite3 php7.1-ldap php7.1-xml php7.1-redis php7.1-imagick php7.1-zip \

# switch php7.0 version before pecl install
    && update-alternatives --set php /usr/bin/php7.0 \
    && pecl config-set php_ini /etc/php/7.0/cli/php.ini \
    && pecl config-set ext_dir /usr/lib/php/20151012 \
    && pecl config-set bin_dir /usr/bin \
    && pecl config-set php_bin /usr/bin/php7.0 \
    && pecl config-set php_suffix 7.0 \

    && pecl install v8js \

    && echo "extension=v8js.so" > /etc/php/7.0/mods-available/v8js.ini \
    && ln -sf /etc/php/7.0/mods-available/v8js.ini /etc/php/7.0/fpm/conf.d/20-v8js.ini \
    && ln -sf /etc/php/7.0/mods-available/v8js.ini /etc/php/7.0/cli/conf.d/20-v8js.ini \
    && ln -sf /etc/php/7.0/mods-available/v8js.ini /etc/php/7.0/cgi/conf.d/20-v8js.ini \

    && sed -i -e "s/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/g" /etc/php/5.6/fpm/php.ini \
    && rm -f /var/lib/ajenti/plugins/vh-nginx/ng*.* \
    && rm -f /var/lib/ajenti/plugins/vh-nginx/*.pyc \
    && rm -f /var/lib/ajenti/plugins/vh-php5.6-fpm/php*.* \
    && rm -f /var/lib/ajenti/plugins/vh-php5.6-fpm/*.pyc \
    && rm -f /var/lib/ajenti/plugins/vh-php7.0-fpm/php*.* \
    && rm -f /var/lib/ajenti/plugins/vh-php7.0-fpm/*.pyc \
    && mkdir -p /var/lib/ajenti/plugins/vh-php7.1-fpm \
    && rm -f /var/lib/ajenti/plugins/vh/main.* \
    && rm -f /var/lib/ajenti/plugins/vh/*.pyc \
    && rm -f /var/lib/ajenti/plugins/vh/api.pyc \
    && rm -f /var/lib/ajenti/plugins/vh/processes.pyc

# add files
ADD ./files /

# update ajenti, install other things
RUN \
    cd /tmp \
    && mkdir -p /ajenti-start/sites \
    && chown -R www-data:www-data /ajenti-start/sites \

# no idea why 1000:1000 but that's the permission ajenti installed with
    && chown -R 1000:1000 /var/lib/ajenti \

# change to more useful folder structure
    && sed -i -e "s/\/srv\/new\-website/\/ajenti\/sites\/new\-website/g" /var/lib/ajenti/plugins/vh/api.py \
    && sed -i -e "s/'php-fcgi'/'php7.1-fcgi'/g" /var/lib/ajenti/plugins/vh/api.py \

    && sed -i -e "s/\/etc\/nginx\/nginx\.conf/\/ajenti\/etc\/nginx\/nginx\.conf/g" /etc/init.d/nginx \

# https://github.com/Eugeny/ajenti-v/pull/185
    && sed -i -e "s/'reload'/'update'/g" /var/lib/ajenti/plugins/vh/processes.py \

# install other things
    && apt-get install -y mongodb-org php-mongodb couchdb nodejs memcached php-memcached redis-server openvpn \
    	postgresql postgresql-contrib easy-rsa bind9 bind9utils bind9-doc \
    && npm install --quiet -g gulp express bower pm2 webpack webpack-dev-server karma protractor typings typescript \
    && npm cache clean \
    && ln -sf "$(which nodejs)" /usr/bin/node

# tweaks
RUN \
    cd /tmp \
    && chmod +x /etc/init.d/mongod \
    && chmod +x /etc/cron.hourly/ajenti-backup-etc \
    && chmod +x /etc/my_init.d/startup.sh \

# increase memcache max size from 64m to 2g
    && sed -i -e "s/^\-m 64/\-m 2048/g" /etc/memcached.conf \

# redirect ajenti default port
    && sed -i -e "s/\"port\"\: 8000/\"port\"\: 9000/g" /etc/ajenti/config.json \

# mongodb stuff
    && mkdir -p /data/db \
    && chmod 0755 /data/db \
    && chown -R mongodb:mongodb /data/db \
    && chmod 0755 /etc/init.d/disable-transparent-hugepages \

# couchdb stuff
    && mkdir -p /var/lib/couchdb \
    && chown -R couchdb:couchdb /usr/bin/couchdb /etc/couchdb /usr/share/couchdb /var/lib/couchdb  \
    && chmod -R 0770 /usr/bin/couchdb /etc/couchdb /usr/share/couchdb /var/lib/couchdb \
 
# secure ssh
    && sed -i -e "s/PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config \

# increase postgresql limit to support at least 8gb ram
    && sed -i -e "s/^max_connections = 100/max_connections = 300/g" /etc/postgresql/9.5/main/postgresql.conf \
    && sed -i -e "s/^shared_buffers = 128MB/shared_buffers = 2048MB/g" /etc/postgresql/9.5/main/postgresql.conf \
    && sed -i -e "s/%q%u@%d '/%q%u@%d %r '/g" /etc/postgresql/9.5/main/postgresql.conf \
    && sed -i -e "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.5/main/postgresql.conf \
    && sed -i -e "s/^#PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config

# php stuff - after ajenti because of ajenti-php installs
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/5.6/fpm/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.0/fpm/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.1/fpm/php.ini \

    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/5.6/fpm/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.0/fpm/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.1/fpm/php.ini \

    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/5.6/fpm/php.ini \
    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.0/fpm/php.ini \
    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.1/fpm/php.ini \

    && sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php/5.6/fpm/php.ini \
    && sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php/7.0/fpm/php.ini \
    && sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php/7.1/fpm/php.ini \

    && service mysql stop \
    && service postgresql stop \
    && service redis-server stop \

    && mkdir -p /ajenti-start/etc-bak \
    && mkdir -p /ajenti-start/etc \
    && mkdir -p /ajenti-start/var/lib \

    && mv /etc/php /ajenti-start/etc/php \
    && rm -rf /etc/php \
    && ln -s /ajenti/etc/php /etc/php \

    && mv /etc/ssh /ajenti-start/etc/ssh \
    && rm -rf /etc/ssh \
    && ln -s /ajenti/etc/ssh /etc/ssh \

    && mv /etc/nginx   /ajenti-start/etc/nginx \
    && rm -rf /etc/nginx \
    && ln -s /ajenti/etc/nginx /etc/nginx \

    && mv /etc/redis   /ajenti-start/etc/redis \
    && rm -rf /etc/redis \
    && ln -s /ajenti/etc/redis /etc/redis \

    && mv /etc/openvpn /ajenti-start/etc/openvpn \
    && rm -rf /etc/openvpn \
    && ln -s /ajenti/etc/openvpn /etc/openvpn \

    && mv /etc/fail2ban /ajenti-start/etc/fail2ban \
    && rm -rf /etc/fail2ban \
    && ln -s /ajenti/etc/fail2ban /etc/fail2ban \

    && mv /etc/ajenti /ajenti-start/etc/ajenti \
    && rm -rf /etc/ajenti \
    && ln -s /ajenti/etc/ajenti /etc/ajenti \

    && mv /etc/mysql   /ajenti-start/etc/mysql \
    && rm -rf /etc/mysql \
    && ln -s /ajenti/etc/mysql /etc/mysql \

    && mv /var/lib/mysql /ajenti-start/var/mysql \
    && rm -rf /var/lib/mysql \
    && ln -s /ajenti/var/mysql /var/lib/mysql \
    
    && mv /var/lib/postgresql /ajenti-start/var/lib/postgresql \
    && rm -rf /var/lib/postgresql \
    && ln -s /ajenti/var/lib/postgresql /var/lib/postgresql \

    && mv /root /ajenti-start/root \
    && rm -rf /root \
    && ln -s /ajenti/root /root \

    && mv /var/lib/ajenti /ajenti-start/var/lib/ajenti \
    && rm -rf /var/lib/ajenti \
    && ln -s /ajenti/var/lib/ajenti /var/lib/ajenti \

    && mv /etc/memcached.conf /ajenti-start/etc/memcached.conf \
    && rm -rf /etc/memcached.conf \
    && ln -s /ajenti/etc/memcached.conf /etc/memcached.conf \

    && mv /etc/timezone /ajenti-start/etc/timezone \
    && rm -rf /etc/timezone \
    && ln -s /ajenti/etc/timezone /etc/timezone \

    && mv /etc/bind /ajenti-start/etc/bind \
    && rm -rf /etc/bind \
    && ln -s /ajenti/etc/bind /etc/bind \

    && mv /etc/profile /ajenti-start/etc/profile \
    && rm -rf /etc/profile \
    && ln -s /ajenti/etc/profile /etc/profile \

    && mv /var/log /ajenti-start/var/log \
    && rm -rf /var/log \
    && ln -s /ajenti/var/log /var/log \

    && mv /etc/mongod.conf /ajenti-start/etc/mongod.conf \
    && rm -rf /etc/mongod.conf \
    && ln -s /ajenti/etc/mongod.conf /etc/mongod.conf \

    && mv /data /ajenti-start/data \
    && rm -rf /ajenti \
    && ln -s /ajenti/data /data \

    && mv /etc/couchdb /ajenti-start/etc/couchdb \
    && rm -rf /etc/couchdb \
    && ln -s /ajenti/etc/couchdb /etc/couchdb \

    && mv /var/lib/couchdb /ajenti-start/var/lib/couchdb \
    && rm -rf /var/lib/couchdb \
    && ln -s /ajenti/var/lib/couchdb /var/lib/couchdb \

    && rm -rf /tmp/*

VOLUME ["/ajenti"]

EXPOSE 22 25 53 54 80 110 443 993 1194 3000 3306 5432 5984 6379 9000 9001 10022 11211 27017