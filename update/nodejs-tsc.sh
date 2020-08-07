#!/bin/bash

user=$1
domain=$2
ip=$3
home=$4
docroot=$5

runuser -l $user -c "yarn install && tsc && NODE_ENV=production pm2 start $home/$user/web/$domain/public_html/src/server.js"