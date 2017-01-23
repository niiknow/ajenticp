#!/bin/bash

export TERM=xterm

if [ -z "`ls /ajenti --hide='lost+found'`" ]
then
    rsync -a /ajenti-start/* /ajenti
fi

# starting Vesta
bash /root/bin/my-startup.sh