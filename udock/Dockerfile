FROM niiknow/docker-hostingbase:0.5.10

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive

# start
RUN apt-get update && apt-get upgrade -y

VOLUME ["/ajenti"]

EXPOSE 80 443 3306 9000 9001 6379