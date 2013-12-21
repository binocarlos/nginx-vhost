nginx-vhost
===========

A bash script to manage nginx virtual hosts and routes to backend HTTP servers.

This is useful when you have lots of backend websites and want a single IP router for them.

## example

This example will setup 2 websites - one with a static folder and the other load-balanced to 2 different backend servers.

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
$ wget -qO- https://raw.github.com/binocarlos/nginx-proxy/master/bootstrap.sh | sudo bash
```

As part of your installation script (as root) - you can use the 'adduser' command so the given user can restart nginx:

```
admin@localhost$ sudo nginx-vhost adduser myuser
```

## usage

### adduser <username>

use this command in your installation script to allow the given username use the 'nginx-vhost' command.

```
$ sudo nginx-vhost adduser git
```

this command must be run as root

## domains <id> [<domains>]

set the domains for a given app id

```
$ nginx-vhost domains myapp myapp.com *.myapp.com
```

## backends <id> [<routes>]

set the backend routes for a given app id

```
$ nginx-vhost backends myapp 127.0.0.1:7463 127.0.0.1:7464
```

## document_root <id> <document_root>

for static websites set the document_root for a given app id

```
$ nginx-vhost document_root myapp /srv/projects/myapp/www
```

## remove <id>

remove a given app id

```
$ nginx-vhost remove myapp
```

## apply

writes out the nginx config files and restarts the server

call this once you have applied your setup

```
$ nginx-vhost apply
```

## License

MIT
