#!/bin/bash

echo "setting nginx.conf"

sed -i -e"s/__RAILS_URL__/${RAILS_URL}/g" /etc/nginx/nginx.conf

echo "starting nginx"
/usr/sbin/nginx -g "daemon off;"
