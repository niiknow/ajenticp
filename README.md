# ajenti docker
Ajenti Docker control panel with Ubuntu 16.04 LTS

# NOTICE
> This repo is no longer being maintained and will be removed shortly.  If you have forked the repo, I will not delete it.   I'm simply just deleting only this repo.

mkdir -p /opt/ajenticp/{backup,ajenti}

docker run -p 80:80 -p 443:443 -p 8000:8000 -p 8001:8001 -v /opt/ajenticp/ajenti:/ajenti -v /opt/ajenticp/backup:/backup -d niiknow/ajenticp

It is important that you have the data volume mounted externally or with a data container.  This will be your data persistent folder

BROWSER
```
https://yourip:8000
```

Default Ajenti user/pass: root/admin

For any issue or help with Ajenti: https://github.com/ajenti/ajenti

phpMyAdmin is setup as a Website on port 8001.  Use MySQL tab to create a user so you can login.  After creating the user, remember to grant access.  Hint: use the "RUN" box to execute your SQL.

# Inspired by
[WhatPanel](https://github.com/paimpozhil/WhatPanel) - but instead of CentOS, I focus on simplifying deployment with latest Ubuntu LTS. 

# Benefits
So you own a cheap VPS and has setuped your perfect server.  Your VPS provider doesn't have snapshot backup or provide little to no backup; and you don't want to mess with your server current configuration.  Docker comes to the rescue.  You can use this project or similar Docker project to provide a stable and secure environment for hosting.

# MIT
