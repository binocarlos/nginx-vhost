#!/usr/bin/env bash
SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
function webserver(){
	while true; do { echo -e 'HTTP/1.1 200 OK\r\n'; cat www/index.html; } | nc -l 8080; done
}
function start_webserver(){
	webserver &
	webserverpid="$!"
}
function stop_webserver(){
	PSTREE=$(pstree -p $webserverpid)
	PIDS=$(echo "$PSTREE" | grep -o '[0-9]\{2,5\}')
	for pid in "$PIDS"
	do
	kill -9 $pid
	done
}
start_webserver
sleep 1
nginx-vhost domains bash "bash.local.digger.io"
nginx-vhost backends bash "127.0.0.1:8080"
nginx-vhost domains static "static.local.digger.io"
nginx-vhost document_root static "$SCRIPT_ROOT/www"
nginx-vhost apply
sleep 1
bash_html=$(wget bash.local.digger.io/index.html -q -O -)
static_html=$(wget static.local.digger.io/index.html -q -O -)
stop_webserver
if [[ $bash_html != *"hello world"* ]]; then
	echo "Bash server did not return content";
	echo "---$bash_html---"
	exit 1;
fi
if [[ $static_html != *"hello world"* ]]; then
	echo "Static server did not return content";
	echo $static_html
	exit 1;
fi
echo "Tests OK"
exit 0;