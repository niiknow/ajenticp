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

# special for docker, we can't set rlimit
RUN rm -f /var/lib/ajenti/plugins/vh-nginx/*.*
ADD ajenti-v/vh-nginx /var/lib/ajenti/plugins/vh-nginx

# update supervisor
RUN sed -i -e "s/\[supervisord\]/\[supervisord\]\nnodaemon=true\n/g" /etc/supervisor/supervisord.conf
ADD supervisor/conf.d /etc/supervisor/conf.d

# update mysql
RUN sed -i -e "s/\/var\/lib\/mysql/\/data\/mysql/g" /etc/mysql/mariadb.conf.d/50-server.cnf

RUN systemctl disable apache-htcacheclean || true

RUN systemctl disable memcached || true && \
	rm -f /etc/init.d/memcached && \
	rm -f /etc/rc3.d/*memcached

RUN systemctl disable ajenti || true && \
	rm -f /etc/init.d/ajenti && \
	rm -f /etc/rc3.d/*ajenti

RUN systemctl disable supervisor || true && \
	rm -f /etc/init.d/supervisor && \
	rm -f /etc/rc3.d/*supervisor

# set root password
RUN echo 'root:Ch@ng3m3' | chpasswd

# entrypoint
ADD docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME ["/data", "/backups"]

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80 443 3306 8000 8001

# using mysqld because mysql is the most stable app here
# if it die, then we should restart docker

CMD ["/usr/bin/supervisord"]