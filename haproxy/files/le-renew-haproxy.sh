#!/bin/bash

web_service='haproxy'
config_file='/usr/local/etc/le-renew-haproxy.ini'
domain=$(grep 'domains = ' /usr/local/etc/le-renew-haproxy.ini | awk '{print $3}')
le_path=$(grep 'webroot-path = ' /usr/local/etc/le-renew-haproxy.ini | awk '{print $3}')
http_01_port='8000'
combined_file="/etc/haproxy/certs/${domain}.pem"

exp_limit=60;

if [ ! -f $config_file ]; then
        echo "[ERROR] config file does not exist: $config_file"
        exit 1;
fi

echo domain $domain
cert_file="/etc/letsencrypt/live/$domain/fullchain.pem"
key_file="/etc/letsencrypt/live/$domain/privkey.pem"

if [ ! -f $cert_file ]; then
	echo "[ERROR] certificate file not found for domain $domain."
fi

exp=$(date -d "`openssl x509 -in $cert_file -text -noout|grep "Not After"|cut -c 25-`" +%s)
datenow=$(date -d "now" +%s)
days_exp=$(echo \( $exp - $datenow \) / 86400 |bc)

echo "Checking expiration date for $domain..."

echo $exp
echo $datenow
echo $days_exp

if [ "$days_exp" -gt "$exp_limit" ] ; then
	echo "The certificate is up to date, no need for renewal ($days_exp days left)."
	exit 0;
else
	echo "The certificate for $domain is about to expire soon. Starting Let's Encrypt (HAProxy:$http_01_port) renewal script..."
	$le_path/letsencrypt-auto certonly --renew-by-default --webroot -w /var/www/html --domains $domain --register-unsafely-without-email --agree-tos
	echo "Creating $combined_file with latest certs..."
	bash -c "cat /etc/letsencrypt/live/$domain/fullchain.pem /etc/letsencrypt/live/$domain/privkey.pem > $combined_file"


	/usr/sbin/service $web_service reload
	echo "Renewal process finished for domain $domain"
	exit 0;
fi
