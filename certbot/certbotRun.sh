#!/bin/sh

if [ -f ${CERTFOLDER}live/${SSLHOST}/fullchain.pem ] && [ -f ${CERTFOLDER}live/${SSLHOST}/privkey.pem ]; then
	certbot renew #--dry-run #--quiet
	# echo "Renew"
else
	certbot certonly --webroot --webroot-path /var/www/certbot/ -m $LE_USER -d $SSLHOST #--dry-run
	# echo "Generate"
fi

