#!/bin/bash
###########

# atd -f &

while true; 
do 
 inotifywait -r --exclude .swp -e create -e modify -e delete -e move /etc/nginx/conf.d/ /etc/nginx/ssl/; 
 nginx -t; 
 if [ $? -eq 0 ]; 
 then 
  echo "Detected Nginx Configuration Change"; 
  echo "Executing: nginx -s reload"; 
  nginx -s reload; 
 fi 
done &

# echo "/usr/bin/certbot-runner.sh" | at now + 1 minute