#!/usr/bin/env bash
set -eo pipefail;
export VHOST_ROOT=${VHOST_ROOT:="/home/nginxvhost"}

# latest stable NGINX 1.4.x with websocket support
add-apt-repository -y ppa:nginx/stable
apt-get update
apt-get install -y nginx dnsutils

if ! grep -q nginx-vhost-reload "/etc/sudoers"; then
  touch /etc/sudoers.tmp
  cp /etc/sudoers /tmp/sudoers.new
  echo "%nginxvhost ALL=(ALL)NOPASSWD:/etc/init.d/nginx reload # nginx-vhost-reload" >> /tmp/sudoers.new
  EDITOR="cp /tmp/sudoers.new" visudo
  rm /tmp/sudoers.new
fi

echo "include $VHOST_ROOT/conf/*.conf;" > /etc/nginx/conf.d/nginxvhost.conf

sed -i 's/# server_names_hash_bucket_size/server_names_hash_bucket_size/' /etc/nginx/nginx.conf

/etc/init.d/nginx start
