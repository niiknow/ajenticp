FROM niiknow/ajenti-udock
MAINTAINER friends <friends@niiknow.org>

# Let say your want to change this to CST
RUN echo "US/Central" > /etc/timezone \
	&& dpkg-reconfigure --frontend=noninteractive tzdata

RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN apt-get update && apt-get upgrade -yq && apt-get install -yq openssh-server

RUN grep -v "Subsystem sftp /usr/lib/openssh/sftp-server" /etc/ssh/sshd_config > /etc/ssh/sshd_config2 && mv /etc/ssh/sshd_config2 /etc/ssh/sshd_config && \
	echo "Subsystem sftp internal-sftp" >> /etc/ssh/sshd_config && \
	echo "Match group www-data" >> /etc/ssh/sshd_config && \
	echo "ChrootDirectory /data/sites/" >> /etc/ssh/sshd_config && \
	echo "X11Forwarding no" >> /etc/ssh/sshd_config && \
	echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
	echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
	useradd -m -g www-data sftpuser

# mongodb 27017
RUN curl -s -o /tmp/percona-server-mongodb-3.2.9-2.1-rd497c75-xenial-x86_64-bundle.tar https://www.percona.com/downloads/percona-server-mongodb-3.2/percona-server-mongodb-3.2.9-2.1/binary/debian/xenial/x86_64/percona-server-mongodb-3.2.9-2.1-rd497c75-xenial-x86_64-bundle.tar && \
    tar -xf /tmp/percona-server-mongodb-3.2.9-2.1-rd497c75-xenial-x86_64-bundle.tar -C /tmp/ && \
    dpkg -i /tmp/percona-server-mongodb-*.deb
RUN easy_install pymongo

# postgresql 5432, openvpn 1194/udp, bind9 53
RUN apt-get install -yq postgresql postgresql-contrib openvpn easy-rsa bind9 bind9utils bind9-doc

# swap out with newer nodejs
RUN apt-get remove -yq nodejs npm && apt-get -y autoremove && \
	dpkg --configure -a && \
	apt-get update && apt-get -yq upgrade && apt-get install -yf

RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install --quiet -g gulp express bower mocha karma-cli pm2 && npm cache clean

ADD docker-entrypoint-greedy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint-greedy.sh

EXPOSE 80 443 3306 9000 9001 6379 22 27017 28017 5432 1194/udp 53

ENTRYPOINT ["docker-entrypoint-greedy.sh"]
