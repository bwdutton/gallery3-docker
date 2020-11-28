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

rm -rf /var/www/local.php
if [ ! -z "${DEVELOPMENT}" ]; then
  cp -rp /local.php /var/www/local.php
fi

sed -i 's/^opcache.*//' /etc/php/7.4/fpm/php.ini

echo "opcache.enable=1" >> /etc/php/7.4/fpm/php.ini
# 18 covers stock gallery, bump up for extra themes/modules
echo "opcache.memory_consumption=24" >> /etc/php/7.4/fpm/php.ini
echo "opcache.validate_timestamps=0" >> /etc/php/7.4/fpm/php.ini
echo "opcache.preload=/var/www/lib/preload_opcache.php" >> /etc/php/7.4/fpm/php.ini
echo "opcache.preload_user=root" >> /etc/php/7.4/fpm/php.ini

chown www-data:www-data /var/www/var

/etc/init.d/nginx start

function stopall() {
	echo "Stopping gallery3..."
	/etc/init.d/nginx stop
}

trap "stopall" SIGKILL SIGTERM SIGHUP SIGINT EXIT

/usr/sbin/php-fpm7.4 --nodaemonize &
wait
