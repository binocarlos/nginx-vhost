#!/usr/bin/env bash
set -eo pipefail
export DEBIAN_FRONTEND=noninteractive
export VHOST_REPO=${DOKKU_REPO:-"https://github.com/binocarlos/nginx-vhost.git"}

if ! which apt-get &>/dev/null
then
  echo "This installation script requires apt-get. For manual installation instructions, consult https://github.com/binocarlos/nginx-vhost ."
  exit 1
fi

apt-get update
apt-get install -y git make curl software-properties-common

[[ `lsb_release -sr` == "12.04" ]] && apt-get install -y python-software-properties

cd ~ && test -d nginx-vhost || git clone $VHOST_REPO
cd nginx-vhost
git fetch origin
make install

echo
echo "nginx-vhost installed"
