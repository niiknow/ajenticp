FROM ubuntu:xenial
MAINTAINER friends <friends@niiknow.org>

# make it non-interactive
ENV DEBIAN_FRONTEND noninteractive

# everyone should be on UTC
RUN echo "Etc/UTC" > /etc/timezone \
	&& dpkg-reconfigure --frontend=noninteractive tzdata

# add files
ADD ajenti/ /etc/ajenti/
ADD backup.d/ /etc/backup.d/
RUN chmod 0600 /etc/backup.* -R
RUN mkdir -p /installers
ADD installers/ /installers/

# run install
ADD ajenti-install.sh /tmp/ajenti-install.sh
RUN bash /tmp/ajenti-install.sh

# set root password
RUN echo 'root:Ch@ng3m3' | chpasswd
RUN echo "ajenti  ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers

# USER test

# entrypoint
ADD docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80 443 3306 8000

CMD ["mysqld"]