#!/bin/bash

export TERM=xterm

if [ -z "`ls /ajenti --hide='lost+found'`" ]
then
    rsync -a /ajenti-start/* /ajenti
fi

# restore current users
if [[ -f /backup/.etc/passwd ]]; then
	# restore users
	rsync -a /backup/.etc/passwd /etc/passwd
	rsync -a /backup/.etc/shadow /etc/shadow
	rsync -a /backup/.etc/gshadow /etc/gshadow
	rsync -a /backup/.etc/group /etc/group
fi

# make sure runit services are running across restart
find /etc/service/ -name "down" -exec rm -rf {} \;

chown www-data:www-data /var/ngx_pagespeed_cache
chmod 750 /var/ngx_pagespeed_cache

if [ -f /etc/nginx/nginx.new ]; then
	mv /etc/nginx/nginx.conf /etc/nginx/nginx.old
	mv /etc/nginx/nginx.new /etc/nginx/nginx.conf
fi

# starting Vesta
echo "[i] running /root/bin/my-startup.sh"
bash /root/bin/my-startup.sh