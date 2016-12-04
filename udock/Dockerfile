FROM ubuntu:xenial
MAINTAINER friends <friends@niiknow.org>

# make it non-interactive
ENV DEBIAN_FRONTEND noninteractive

# everyone should be on UTC
#RUN timedatectl set-timezone Etc/UTC
RUN echo "US/Central" > /etc/timezone \
	&& dpkg-reconfigure --frontend=noninteractive tzdata

# add files
ADD ajenti /etc/ajenti/
ADD backup.d /etc/backup.d/
RUN chmod 0600 /etc/backup.* -R

# run install
ADD ajenti-install.sh ajenti-install.sh
RUN bash ajenti-install.sh

# entrypoint
ADD entrypoint.sh /usr/sbin/entrypoint.sh
RUN chmod +x /usr/sbin/entrypoint.sh

EXPOSE 80 443 3306 8000

CMD ["/usr/sbin/entrypoint.sh"]