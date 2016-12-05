FROM niiknow:ajenti-udock
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
RUN echo "ChrootDirectory /srv/" >> /etc/ssh/sshd_config
RUN echo "X11Forwarding no" >> /etc/ssh/sshd_config
RUN echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config
RUN echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
RUN useradd -m -g www-data sftpuser

# mongodb 27017
apt-get install -yq mongodb-org

# postgresql 5432
apt-get install -yq postgresql postgresql-contrib

# bind9 53
apt-get install -yq bind9 bind9utils bind9-doc

# Let swap out with a different nodejs
RUN apt-get remove -yq node npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install -g gulp express forever flatiron

EXPOSE 80 443 3306 8000 22 27017 5432 53