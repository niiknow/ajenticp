# ajenti docker
Ajenti Docker web panel with Ubuntu 16.04 LTS

Build
```
cd udock
docker build -t niiknow/ajenti-udock:0.1.0 udock
docker tag niiknow/ajenti-udock:0.1.0 niiknow/ajenti-udock:latest
```

RUN
```
docker run -p 8000:8000 -p 80:80 -p 443:443 -p 3306:3306 -v /opt/ajenti-udock/sites:/data/sites -v /opt/ajenti-udock/mysql:/var/lib/mysql -e MYSQL_ADMIN_PASSWORD=yourMySqlpass -d niiknow/ajenti-udock
```

BROWSER
```
https://yourip:8000
```

Default Ajenti user/pass: root/admin
For any issue or help with Ajenti: https://github.com/ajenti/ajenti

## ajenti-install.sh
This script can be use to install Ajenti on Ubuntu 16.04 LTS.  It provides basic plugin and various fixes that make Ajenti possible on Ubuntu 16.04 LTS.

1. Install *apt-utils* early so it does not warn in later steps.
2. Install *apt-show-versions* and force update to prevent Ajenti dependency errors.
3. Add phpMyAdmin of course.
4. If nodejs not exists, use apt-get to install default nodejs.  You can easily apt-get remove and/or reinstall from a different source later.  
5. Install plugins: nginx mysql/MariaDB php5.6-fpm php7.0-fpm mail nodejs python-gunicorn ruby-unicorn.
6. Also include tools that you need to be productive in a terminal like wget, curl, git, sudo, and nano.
7. Modify Ajenti default website folder from /srv/new-website to /data/sites/new-website.

That should be enough for you to start your website hosting.  MySql is included for convienence, but it's best to host mysql on a separate container.

## ajenti-udock
This is the base docker image of ajenti-udock with basic requirements:

1. Set timezone to UTC activate Ajenti terminal.  You should be able to configure your timezone in your own Dockerfile (see udock-greedy).
2. Trigger *ajenti-install.sh* and expose 80/http, 443/https, 3306/mysql, and 8000/ajenti.

This image expect all management through the web panel.  There is no ssh.  If you need terminal access then use the web panel, docker cloud, or even running with rancher.

```
https://yourip:8000
```

## ajenti-udock-greedy
So you want everything?  This demonstrate the greedy udock setup with: ajenti-udock + sftp, postgresql, mongodb, openvpn, and bind9.  Also swap out with latest nodejs 6.x and npm install gulp, express, forever, and flatiron.

From this image, you can figure out how to simply setup your own from the base ajenti-udock panel.

Since we're running docker, you can choose to expose as much or as little port as you like with your docker port mapping.  Example below show the addition of openvpn.

```
docker run -p 8000:8000 -p 80:80 -p 443:443 -p 3306:3306 -p 1194:1194/udp -v /opt/ajenti-udock/sites:/data/sites -v /opt/ajenti-udock/mysql:/var/lib/mysql -e MYSQL_ADMIN_PASSWORD=yourMySqlpass -d niiknow/ajenti-udock-greedy
```

TODO
* I need to standardize Ajenti folder to keep data for all these apps to simplify volumn mapping.

# Inspired by
[WhatPanel] (https://github.com/paimpozhil/WhatPane) - but instead of CentOS, I use focus on simplifying deployment with latest Ubuntu LTS.  I also want to provide directly for full blown Ajenti docker image.

# Benefits
So you purchased a cheap VPS hosting and setup your perfect and secure server.  Your VPS provider doesn't have snapshot kind of backup or provide little to no backup; and you don't want to mess with the server stability.  Docker comes to the rescue.  You can use this project or similar to provide a more flexible, stable, and secure environment for hosting.

If you don't have docker but has access to Ubuntu 16.04, you can use the ajenti-install.sh directly.

```
wget https://raw.githubusercontent.com/niiknow/ajenti-udock/master/udock/ajenti-install.sh
bash ajenti-install.sh
```

# Signing Off
Project is currently *not actively worked on* since parent project (Ajenti) also seem to be in the same status.  This make it difficult to justify running this in Production so I'm not actively using this project.  I'm just doing this as proof of concept.

Otherwise, if you have any requests, create an issue/pull request and I will try to find the time.

# LICENSE
The MIT License (MIT)

Copyright (c) 2016 niiknow

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.