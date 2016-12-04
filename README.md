# ajenti docker
Ajenti Docker web panel with Ubuntu 16.04 LTS

Build
```
cd udock
docker build -t niiknow/ajenti-udock:0.0.1 udock
docker tag niiknow/ajenti-udock:0.0.1 niiknow/ajenti-udock:latest
```

RUN
```
docker run -p 8000:8000 -p 80:80 -p 443:443 -p 3306:3306 -v /opt/ajenti-udock/www:/srv -v /opt/ajenti-udock/data:/data -v /opt/ajenti-udock/backup:/backup -v /opt/ajenti-udock/mysql:/var/lib/mysql -e MYSQL_ADMIN_PASSWORD=yourMySqlpass -d niiknow/ajenti-udock
```

BROWSER
```
https://yourip:8000
```

## ajenti-install.sh
This script can be use to install Ajenti on Ubuntu 16.04 LTS.  It provides basic plugin and various fixes to make Ajenti possible on Ubuntu 16.04 LTS.

1. Install *apt-utils* early so it does not warn in later steps.
2. Install *apt-show-versions* and force update to prevent Ajenti dependency errors.
3. Add phpMyAdmin of course.
4. If nodejs not exists, use apt-get to install default nodejs.  You can easily apt-get remove and/or reinstall from a different source later.  
5. Install plugins: nginx mysql php5.6-fpm php7.0-fpm mail nodejs python-gunicorn ruby-unicorn.

That should be enough for you to start your website hosting.  MySql is included for convienence, but it's best to host mysql on a separate container.

## ajenti-udock
This is the base docker image of ajenti-udock with basic requirements:

1. Set timezone to UTC activate Ajenti terminal.  You should be able to configure your timezone in your own Dockerfile. 
2. Trigger *ajenti-install.sh* and expose 80/http, 443/https, 3306/mysql, and 8000/ajenti.

This image expect all management through the web panel.  There is no ssh.  If you need terminal then go through the web panel, docker cloud, or rancher.

```
https://yourip:8000
```

## ajenti-udock-greedy
So you want everything?  This demonstrate the greedy udock setup with: ajenti-udock, sftp, postgresql, mongodb, bind9, and disable https for Ajenti.

From this image, you can figure out how to simply setup your own from the base ajenti-udock panel.

# Inspired by
[WhatPanel] (https://github.com/paimpozhil/WhatPane)

# Signing Off
Project is currently abandoned since parent project (Ajenti) also seem to be abandoned.  

# LICENSE
The MIT License (MIT)

Copyright (c) 2016 niiknow

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.