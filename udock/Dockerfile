FROM ubuntu:xenial
MAINTAINER friends <friends@niiknow.org>

# make it non-interactive
ENV DEBIAN_FRONTEND noninteractive
ENV LANG=C.UTF-8

# everyone should be on UTC
RUN echo "Etc/UTC" > /etc/timezone \
	&& dpkg-reconfigure --frontend=noninteractive tzdata

# fix locales warning on Ajenti Terminal
RUN apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG && \
    locale-gen en_US en_US.UTF-8

# add files
ADD ajenti/ /etc/ajenti/
ADD backup.d/ /etc/backup.d/
RUN chmod 0600 /etc/backup.* -R
RUN mkdir -p /installers
ADD installers/ /installers/

# run install
ADD ajenti-install.sh /tmp/ajenti-install.sh
RUN bash /tmp/ajenti-install.sh

# special ajenti-v for docker
RUN rm -f /var/lib/ajenti/plugins/vh-nginx/ng*.*
ADD ajenti-v/vh-nginx/ng*.* /var/lib/ajenti/plugins/vh-nginx

RUN rm -f /var/lib/ajenti/plugins/vh-php5.6-fpm/php*.*
ADD ajenti-v/vh-php5.6-fpm/php*.* /var/lib/ajenti/plugins/vh-php5.6-fpm

RUN rm -f /var/lib/ajenti/plugins/vh-php7.0-fpm/php*.*
ADD ajenti-v/vh-php7.0-fpm/php*.* /var/lib/ajenti/plugins/vh-php7.0-fpm

# RUN mkdir -p /var/lib/ajenti/plugins/vh-php7.1-fpm && rm -f /var/lib/ajenti/plugins/vh-php7.1-fpm/*.*
# ADD ajenti-v/vh-php7.1-fpm /var/lib/ajenti/plugins/vh-php7.1-fpm
# ADD ajenti-v/vh/layout/main-backend-params-php7.1-fcgi.xml /var/lib/ajenti/plugins/vh/layout/main-backend-params-php7.1-fcgi.xml

RUN rm -f /var/lib/ajenti/plugins/vh/main.*
ADD ajenti-v/vh/main.py /var/lib/ajenti/plugins/vh/main.py

# update supervisor
# RUN sed -i -e "s/\[supervisord\]/\[supervisord\]\nnodaemon=true\n/g" /etc/supervisor/supervisord.conf
ADD supervisor/conf.d /etc/supervisor/conf.d

# update mysql
RUN sed -i -e "s/\/var\/lib\/mysql/\/data\/mysql/g" /etc/mysql/mariadb.conf.d/50-server.cnf

# update redis
RUN sed -i -e "s/dir \./dir \/data\/redis\/db/g" /etc/redis/redis.conf

# update fpm
RUN sed -i -e "s/\/etc\/php\/5\.6\/fpm\/pool\.d/\/data\/php\/5\.6\/fpm\/pool\.d/g" /etc/php/5.6/fpm/php-fpm.conf
RUN sed -i -e "s/\/etc\/php\/7\.0\/fpm\/pool\.d/\/data\/php\/7\.0\/fpm\/pool\.d/g" /etc/php/7.0/fpm/php-fpm.conf
# RUN sed -i -e "s/\/etc\/php\/7\.1\/fpm\/pool\.d/\/data\/php\/7\.1\/fpm\/pool\.d/g" /etc/php/7.1/fpm/php-fpm.conf

RUN systemctl disable apache-htcacheclean || true && \
	rm -f /etc/init.d/apache-htcacheclean && \
	rm -f /etc/rc3.d/*apache-htcacheclean

RUN systemctl disable redis || true && \
	rm -f /etc/init.d/redis && \
	rm -f /etc/rc3.d/*redis

RUN systemctl disable ajenti || true && \
	rm -f /etc/init.d/ajenti && \
	rm -f /etc/rc3.d/*ajenti

RUN systemctl enable php5.6-fpm || true
RUN systemctl enable php7.0-fpm || true
# RUN systemctl enable php7.1-fpm || true
RUN systemctl enable nginx || true
RUN systemctl enable supervisor || true
RUN systemctl enable cron || true

# set root password
RUN echo 'root:Ch@ng3m3' | chpasswd

# entrypoint
ADD docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME ["/data", "/backups"]

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80 443 3306 8000 8001

# this ensure that we don't exit the docker, ever
CMD ["tail", "-f", "/dev/null"]