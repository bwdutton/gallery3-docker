#!/bin/bash

# can't be done during container build or we'll end up with hardcoded values

sed -i 's/date\.timezone.*//' /etc/php/7.4/cli/php.ini /etc/php/7.4/fpm/php.ini
echo "date.timezone = ${TZ}" >> /etc/php/7.4/cli/php.ini
echo "date.timezone = ${TZ}" >> /etc/php/7.4/fpm/php.ini

sed -i 's/env\[SITE_DOMAIN\].*//' /etc/php/7.4/fpm/pool.d/www.conf
if [ ! -z "${SITE_DOMAIN}" ]; then
  echo "env[SITE_DOMAIN] = ${SITE_DOMAIN}" >> /etc/php/7.4/fpm/pool.d/www.conf
fi

sed -i 's/env\[SITE_PROTOCOL\].*//' /etc/php/7.4/fpm/pool.d/www.conf
if [ ! -z "${SITE_PROTOCOL}" ]; then
  echo "env[SITE_PROTOCOL] = ${SITE_PROTOCOL}" >> /etc/php/7.4/fpm/pool.d/www.conf
fi

chown www-data:www-data /var/www/var

/etc/init.d/nginx start

function stopall() {
	echo "Stopping gallery3..."
	/etc/init.d/nginx stop
}

trap "stopall" SIGKILL SIGTERM SIGHUP SIGINT EXIT

/usr/sbin/php-fpm7.4 --nodaemonize &
wait
