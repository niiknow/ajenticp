# ajenti docker
Ajenti Docker control panel with Ubuntu 16.04 LTS

mkdir -p /opt/ajenti

docker run -p 80:80 -p 443:443 -p 3306:3306 -p 9000:9000 -p 9001:9001 -v /opt/ajenti:/ajenti -d niiknow/ajenti-udock

It is important that you have the data volume mounted externally or with a data container.  This will be your data persistent folder

BROWSER
```
https://yourip:9000
```

Ajenti was changed from 8000 to 9000 for better compatibility with other/future apps.

Default Ajenti user/pass: root/admin

For any issue or help with Ajenti: https://github.com/ajenti/ajenti

phpMyAdmin is setup as a Website on port 9001.  Use MySQL tab to create a user so you can login.  After creating the user, remember to grant access.  Hint: use the "RUN" box to execute your SQL.

# Inspired by
[WhatPanel](https://github.com/paimpozhil/WhatPanel) - but instead of CentOS, I focus on simplifying deployment with latest Ubuntu LTS. 

# Benefits
So you own a cheap VPS and has setuped your perfect server.  Your VPS provider doesn't have snapshot backup or provide little to no backup; and you don't want to mess with your server current configuration.  Docker comes to the rescue.  You can use this project or similar Docker project to provide a stable and secure environment for hosting.

# LICENSE

The MIT License (MIT)

Copyright (c) 2017 friends@niiknow.org

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.