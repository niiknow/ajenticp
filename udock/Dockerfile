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

# set root password
RUN echo 'root:Ch@ng3m3' | chpasswd
RUN echo "ajenti  ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers

# USER test

# entrypoint
ADD docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80 443 3306 8000 8001

CMD ["mysqld"]