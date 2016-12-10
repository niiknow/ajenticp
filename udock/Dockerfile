FROM ubuntu:xenial
MAINTAINER friends <friends@niiknow.org>

# everyone should be on UTC and fix locales warning on Ajenti Terminal
RUN echo "Etc/UTC" > /etc/timezone && \
	dpkg-reconfigure --frontend=noninteractive tzdata && \
	apt-get install -y locales && \
    sed -i -e "s/# C.UTF-8.*/C.UTF-8.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=C.UTF-8 && \
    locale-gen en_US en_US.UTF-8 && \
    mkdir -p /installers && \
	mkdir -p /etc/backup.d 

# add files and run install
ADD ajenti/ /etc/ajenti/
ADD backup.d/ /etc/backup.d/
ADD installers/ /installers/
ADD ajenti-install.sh /tmp/ajenti-install.sh
RUN bash /tmp/ajenti-install.sh

# special ajenti-v for docker
RUN rm -f /var/lib/ajenti/plugins/vh-nginx/ng*.* && \
	rm -f /var/lib/ajenti/plugins/vh-nginx/*.pyc
ADD ajenti-v/vh-nginx/ng*.* /var/lib/ajenti/plugins/vh-nginx/
RUN chown 1000:1000 /var/lib/ajenti/plugins/vh-nginx/ng*.py

RUN rm -f /var/lib/ajenti/plugins/vh-php5.6-fpm/php*.* && \
	rm -f /var/lib/ajenti/plugins/vh-php5.6-fpm/*.pyc
ADD ajenti-v/vh-php5.6-fpm/php*.* /var/lib/ajenti/plugins/vh-php5.6-fpm/
RUN chown 1000:1000 /var/lib/ajenti/plugins/vh-php5.6-fpm/php*.*

RUN rm -f /var/lib/ajenti/plugins/vh-php7.0-fpm/php*.* && \
	rm -f /var/lib/ajenti/plugins/vh-php7.0-fpm/*.pyc
ADD ajenti-v/vh-php7.0-fpm/php*.* /var/lib/ajenti/plugins/vh-php7.0-fpm/
RUN chown 1000:1000 /var/lib/ajenti/plugins/vh-php7.0-fpm/php*.*

RUN mkdir -p /var/lib/ajenti/plugins/vh-php7.1-fpm && \
	rm -f /var/lib/ajenti/plugins/vh-php7.1-fpm/*.*
ADD ajenti-v/vh-php7.1-fpm /var/lib/ajenti/plugins/vh-php7.1-fpm
RUN chown 1000:1000 /var/lib/ajenti/plugins/vh-php7.1-fpm/*.*

ADD ajenti-v/vh/layout/main-backend-params-php7.1-fcgi.xml /var/lib/ajenti/plugins/vh/layout/main-backend-params-php7.1-fcgi.xml
RUN chown 1000:1000 /var/lib/ajenti/plugins/vh/layout/main-backend-params-php7.1-fcgi.xml

RUN rm -f /var/lib/ajenti/plugins/vh/main.* && \
	rm -f /var/lib/ajenti/plugins/vh/*.pyc
ADD ajenti-v/vh/main.py /var/lib/ajenti/plugins/vh/main.py
RUN chown 1000:1000 /var/lib/ajenti/plugins/vh/*.py
ADD phpMyAdmin/config.inc.php /tmp/config.inc.php

# update supervisor
ADD supervisor/conf.d /etc/supervisor/conf.d

# update backupninja, supervisor, mysql, redis, fpm
RUN sed -i -e "s/configdirectory = \/etc/configdirectory = \/data/g" /etc/backupninja.conf && \
	sed -i -e "s/files = \/etc/files = \/data/g" /etc/supervisor/supervisord.conf && \
	sed -i -e "s/\/var\/lib\/mysql/\/data\/mysql/g" /etc/mysql/mariadb.conf.d/50-server.cnf && \
	sed -i -e "s/dir \./dir \/data\/redis\/db/g" /etc/redis/redis.conf && \
	sed -i -e "s/\/etc\/php\/5\.6\/fpm\/pool\.d/\/data\/php\/5\.6\/fpm\/pool\.d/g" /etc/php/5.6/fpm/php-fpm.conf && \
	sed -i -e "s/\/etc\/php\/7\.0\/fpm\/pool\.d/\/data\/php\/7\.0\/fpm\/pool\.d/g" /etc/php/7.0/fpm/php-fpm.conf && \
	sed -i -e "s/\/etc\/php\/7\.1\/fpm\/pool\.d/\/data\/php\/7\.1\/fpm\/pool\.d/g" /etc/php/7.1/fpm/php-fpm.conf && \
	printf "\nDAEMON_OPTS=-c /data/nginx/nginx.conf\nDAEMON_ARGS=\$DAEMON_OPTS" >> /etc/default/nginx

RUN systemctl disable apache-htcacheclean || true && \
	rm -f /etc/init.d/apache-htcacheclean && \
	rm -f /etc/rc3.d/*apache-htcacheclean && \
	systemctl disable redis || true && \
	rm -f /etc/init.d/redis && \
	rm -f /etc/rc3.d/*redis && \
	systemctl disable nginx || true && \
	rm -f /etc/init.d/nginx && \
	rm -f /etc/rc3.d/*nginx

RUN systemctl enable php5.6-fpm || true && \
	systemctl enable php7.0-fpm || true && \
	systemctl enable php7.1-fpm || true && \
	systemctl enable nginx || true && \
	systemctl enable supervisor || true && \
	systemctl enable cron || true && \
	systemctl enable ajenti || true && \
	echo 'root:Ch@ng3m3' | chpasswd

# entrypoint
ADD docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME ["/data", "/backups"]

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80 443 3306 8000 8001 6379

# this ensure that we don't exit the docker, ever
CMD ["tail", "-f", "/dev/null"]