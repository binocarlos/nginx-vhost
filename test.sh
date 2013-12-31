#!/usr/bin/env bash
SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
nginx-vhost domains static "static.local.digger.io"
nginx-vhost document_root static "$SCRIPT_ROOT/www"
nginx-vhost apply
sleep 1
static_html=$(wget static.local.digger.io/index.html -q -O -)
nginx-vhost remove static
nginx-vhost apply
if [[ $static_html != *"hello world"* ]]; then
	echo "Static server did not return content";
	echo $static_html
	exit 1;
fi
echo "Tests OK"
exit 0;