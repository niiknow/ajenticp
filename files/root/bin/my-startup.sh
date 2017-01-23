#!/bin/sh
# restore current users
if [[ -f /ajenti/etc-bak/passwd ]]; then
	# restore users
	rsync -a /ajenti/etc-bak/passwd /etc/passwd
	rsync -a /ajenti/etc-bak/shadow /etc/shadow
	rsync -a /ajenti/etc-bak/gshadow /etc/gshadow
	rsync -a /ajenti/etc-bak/group /etc/group
fi

# only if you run in privileged mode
# if [[ -f /etc/fail2ban/jail.new ]]; then
#     mv /etc/fail2ban/jail.local /etc/fail2ban/jail.local-bak
#     mv /etc/fail2ban/jail.new /etc/fail2ban/jail.local
# fi

# re-enable phpmyadmin and phppgadmin
# rsync -a /ajenti-start/etc-bak/apache2/conf.d/php*.conf /etc/apache2/conf.d

# required startup and of course ajenti
cd /etc/init.d/
./disable-transparent-hugepages defaults \
&& ./ssh start \
&& ./supervisor start \
&& ./ajenti start
