FROM niiknow:ajenti-udock
MAINTAINER friends <friends@niiknow.org>

# Let say your want to change this to CST
RUN echo "US/Central" > /etc/timezone \
	&& dpkg-reconfigure --frontend=noninteractive tzdata

# Let swap out with a different nodejs
RUN apt-get remove -yq node npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install -g gulp express

# sftp
RUN apt-get install -yq openssh-server 
RUN grep -v "Subsystem sftp /usr/lib/openssh/sftp-server" /etc/ssh/sshd_config > /etc/ssh/sshd_config2 && mv /etc/ssh/sshd_config2 /etc/ssh/sshd_config
RUN echo "Subsystem sftp internal-sftp" >> /etc/ssh/sshd_config
RUN echo "Match group www-data" >> /etc/ssh/sshd_config
RUN echo "ChrootDirectory /srv/" >> /etc/ssh/sshd_config
RUN echo "X11Forwarding no" >> /etc/ssh/sshd_config
RUN echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config
RUN echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
RUN useradd -m -g www-data sftpuser

EXPOSE 80 443 3306 8000 22