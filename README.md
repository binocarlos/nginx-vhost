nginx-vhost
===========

![Build status](https://api.travis-ci.org/binocarlos/nginx-vhost.png)

A bash script wrapper for nginx that makes it easy load balance HTTP to multiple backend app servers.

```
    INTERNET
        |
        |
    PUBLIC_IP:80 (nginx)
    /   |   \
   /    |    \
app1   app2  app3
```

It works by managing /etc/nginx/conf.d/*.conf vhost files and sudo restart permissions.

## example

This example will setup 2 websites.

The first has a static folder and the other is load-balanced to 2 different backend servers.

```bash
#!/usr/bin/env bash

# first setup the static website
nginx-vhost domains staticapp static.myapp.com
nginx-vhost document_root staticapp /srv/projects/app/static/www

# now the proxied app
nginx-vhost domains app myapp.com *.myapp.com
nginx-vhost backends app 127.0.0.1:8791 127.0.0.1:8792

# then apply what we have done
nginx-vhost apply
```

## installation

```
$ wget -qO- https://raw.github.com/binocarlos/nginx-vhost/master/bootstrap.sh | sudo bash
```

As part of your installation script - you can use the 'adduser' command.

```
admin@localhost$ sudo nginx-vhost adduser myuser
```

myuser is now able to call 'nginx-vhost apply' and 'nginx-vhost reload' - the group permissions are allocated
so that myuser can restart nginx.

## usage

### useradd <username>

use this command in your installation script to allow the given username use the 'nginx-vhost' command.

```
$ sudo nginx-vhost useradd git
```

this command should be run once and as root

### domains <id> <domains>

set the domains for a given app id

```
$ nginx-vhost domains myapp myapp.com *.myapp.com
```

### backends <id> [<routes>]

set the backend routes for a given app id

```
$ nginx-vhost backends myapp 127.0.0.1:7463 127.0.0.1:7464
```

### document_root <id> <document_root>

for static websites set the document_root for a given app id

```
$ nginx-vhost document_root myapp /srv/projects/myapp/www
```

### remove <id>

remove a given app id

```
$ nginx-vhost remove myapp
```

### apply

writes out the nginx config files and restarts the server

call this once you have applied your setup

```
$ nginx-vhost apply
```

## License

MIT
