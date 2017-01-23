FROM niiknow/docker-hostingbase:0.5.10

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive

# start
RUN \
	cd /tmp \
	&& wget http://repo.ajenti.org/debian/key -O- | apt-key add - \
	&& echo "deb http://repo.ajenti.org/debian main main ubuntu" > /etc/apt/sources.list.d/ajenti.list \

	&& apt-get update && apt-get upgrade -y \
	&& apt-get install -yq ajenti php-all-dev pkg-php-tools \
    && apt-get install -yq ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php5.6-fpm \
	    ajenti-v-php7.0-fpm ajenti-v-mail ajenti-v-nodejs ajenti-v-python-gunicorn ajenti-v-ruby-unicorn \

    && pecl install v8js \

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



VOLUME ["/ajenti"]

EXPOSE 80 443 3306 9000 9001 6379