FROM niiknow/ajenti-udock
MAINTAINER friends <friends@niiknow.org>

# Let say your want to change this to CST
RUN echo "US/Central" > /etc/timezone \
	&& dpkg-reconfigure --frontend=noninteractive tzdata

RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN apt-get update && apt-get upgrade

# sftp 22
RUN apt-get install -yq openssh-server 
RUN grep -v "Subsystem sftp /usr/lib/openssh/sftp-server" /etc/ssh/sshd_config > /etc/ssh/sshd_config2 && mv /etc/ssh/sshd_config2 /etc/ssh/sshd_config
RUN echo "Subsystem sftp internal-sftp" >> /etc/ssh/sshd_config
RUN echo "Match group www-data" >> /etc/ssh/sshd_config
RUN echo "ChrootDirectory /data/sites/" >> /etc/ssh/sshd_config
RUN echo "X11Forwarding no" >> /etc/ssh/sshd_config
RUN echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config
RUN echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
RUN useradd -m -g www-data sftpuser

# mongodb 27017
RUN curl -s -o /tmp/percona-server-mongodb-3.2.9-2.1-rd497c75-xenial-x86_64-bundle.tar https://www.percona.com/downloads/percona-server-mongodb-3.2/percona-server-mongodb-3.2.9-2.1/binary/debian/xenial/x86_64/percona-server-mongodb-3.2.9-2.1-rd497c75-xenial-x86_64-bundle.tar && \
    tar -xf /tmp/percona-server-mongodb-3.2.9-2.1-rd497c75-xenial-x86_64-bundle.tar -C /tmp/ && \
    dpkg -i /tmp/percona-server-mongodb-*.deb
RUN easy_install pymongo

# postgresql 5432
RUN apt-get install -yq postgresql postgresql-contrib

# openvpn 1194/udp
RUN apt-get install -yq openvpn easy-rsa

# bind9 53
RUN apt-get install -yq bind9 bind9utils bind9-doc

# Let swap out with a different nodejs
RUN rm -rf /bin/node
RUN apt-get remove -yq nodejs npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs npm
RUN npm install -g gulp express

EXPOSE 80 443 3306 8000 22 27017 5432 1194/udp 53