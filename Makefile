VHOST_VERSION = master
VHOST_ROOT ?= /home/nginxvhost

.PHONY: all install copyfiles dependencies nginx

all:
	# Type "make install" to install.

install: dependencies copyfiles

dependencies: nginx

folders:
	useradd -b ${VHOST_ROOT} -s /bin/bash -g nginxvhost nginxvhost
	mkdir -p ${VHOST_ROOT}
	mkdir -p ${VHOST_ROOT}/conf
	mkdir -p ${VHOST_ROOT}/db
	chown -R nginxvhost:nginxvhost ${VHOST_ROOT}
	chmod -R g+w ${VHOST_ROOT}

copyfiles:	
	cp nginx-vhost /usr/local/bin/nginx-vhost

nginx:	
	./install