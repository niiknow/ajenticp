#!/bin/bash

export TERM=xterm

if [ -z "`ls /ajenti --hide='lost+found'`" ]
then
    rsync -a /ajenti-start/* /ajenti
fi

# restore current users
if [[ -f /backup/etc/passwd ]]; then
	# restore users
	rsync -a /backup/etc/passwd /etc/passwd
	rsync -a /backup/etc/shadow /etc/shadow
	rsync -a /backup/etc/gshadow /etc/gshadow
	rsync -a /backup/etc/group /etc/group
fi

# start incron after restore
cd /etc/init.d/
./incron start

# starting Vesta
bash /root/bin/my-startup.sh