#!/bin/sh
#set -e

echo "Docker entrypoint start"


sed -i "s/#ServerName www.example.com:80/ServerName ${APACHE_SERVER_NAME}/" /etc/apache2/httpd.conf

# Start http
echo "Start httpd"
httpd -D FOREGROUND
