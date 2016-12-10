# ajenti docker
Ajenti Docker web panel with Ubuntu 16.04 LTS.

RUN
```
docker run -p 8000:8000 -p 80:80 -p 443:443 -p 3306:3306 -p 8001:8001 -v /opt/ajenti-udock/data:/data -d niiknow/ajenti-udock
```

It is important that you have the data volume mounted externally or to a data container.  This will be your data persistent folder

BROWSER
```
https://yourip:8000
```

VOLUME "/data"
```
/data/ajenti - persist Ajenti configs across restart
/data/backup.d - allow for customizing backupninja configuration
/data/nginx - all your nginx configs
/data/mysql - mysql raw data folder
/data/mysqldump - mysql dump backup folder
/data/php - php and fpm configurations
/data/redis - redis configuration
/data/redis/db - redis persistent configuration
/data/sites - website files
/data/supervisor - supervisor configs
```

Default Ajenti user/pass: root/admin
For any issue or help with Ajenti: https://github.com/ajenti/ajenti

## ajenti-install.sh
This script can be use to install Ajenti on Ubuntu 16.04 LTS.  It provides basic plugin and various fixes that make Ajenti possible on Ubuntu 16.04 LTS.

1. Install *apt-utils* early so it does not warn in later steps.
2. Install *apt-show-versions* and force update to prevent Ajenti dependency errors.
3. If nodejs not exists, use apt-get to install default nodejs.  You can easily apt-get remove and/or reinstall from a different source later.  
4. Install plugins: nginx mysql/MariaDB php5.6-fpm php7.0-fpm mail nodejs python-gunicorn ruby-unicorn.
5. Also include tools that you need to be productive in a terminal like wget, curl, git, sudo, and nano.
6. Modify Ajenti default website folder from /srv/new-website to /data/sites/new-website.
7. Rework ajenti-v/vh-nginx plugin to provide better stability and reuse.  This is an experiment of mine, and if it work, then I will try to get a change request to Ajenti.
8. phpMyAdmin is setup as a Website on port 8001.  In order to use phpMyAdmin for the first time, you will need to go to Ajenti Websites tab, apply the config so that Ajenti generate the nginx config for this site.  Then restart php7.0-fpm service and start nginx service.  Goto MySQL tab and create a new user, let say 'ajenti'@'localhost' with your own password and "RUN" the statement: "GRANT ALL PRIVILEGES ON *.* TO 'ajenti'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;" and now you can login with user ajenti on port 8001.
9. For backup conveniences, almost everything has been redirected to your "/data" VOLUME.  Just backup your mounted volume on a regular basis and you are good to go.  Or create a data container and run regular snapshot on the container for easy rollback.  Backupninja has also been configured to send file to /backup volume with daily default schedule at 1AM.  Just mount the volume externally to get access.

That should be enough for you to start your website hosting.  MySql is included for convienence, but it's best to host mysql on a separate container.

## ajenti-udock
This is the base docker image of ajenti-udock with basic requirements:

1. Set timezone to UTC as default but you should be able to configure your timezone in your own Dockerfile (see udock-greedy).
2. Trigger *ajenti-install.sh* and expose 80/http, 443/https, 3306/mysql, 6379/redis, 8000/ajenti, and 8001/phpMyAdmin.

This image expect all management through the web panel.  There is no ssh.  If you need terminal access then use the web panel, docker cloud, or even running with rancher.

```
https://yourip:8000
```

## ajenti-udock:greedy
So you want everything?  This demonstrate the greedy udock setup with: ajenti-udock + sftp, postgresql, mongodb, openvpn, and bind9.  Also swap out with latest nodejs 6.x with npm install gulp and express.

From this image, you can figure out how to simply setup your own Dockerfile with the base ajenti-udock panel.

Since we're running docker, you can choose to expose as much or as little port as you like with your docker port mapping.  Example below show the addition of openvpn.

```
docker run -p 8000:8000 -p 80:80 -p 443:443 -p 3306:3306 -p 8001:8001 -p 1194:1194/udp -v /opt/ajenti-udock/data:/data -d niiknow/ajenti-udock-greedy
```

# Inspired by
[WhatPanel] (https://github.com/paimpozhil/WhatPane) - but instead of CentOS, I focus on simplifying deployment with latest Ubuntu LTS.  I also want to provide the base for full blown Ajenti docker image: ajenti-udock:greedy.

# Benefits
So you own a cheap VPS and has setuped your perfect server.  Your VPS provider doesn't have snapshot backup or provide little to no backup; and you don't want to mess with your server current configuration.  Docker comes to the rescue.  You can use this project or similar to provide a stable and secure environment for hosting.

If you don't have docker but has access to Ubuntu 16.04, you can use the ajenti-install.sh directly.

```
wget https://raw.githubusercontent.com/niiknow/ajenti-udock/master/udock/ajenti-install.sh
bash ajenti-install.sh
```
