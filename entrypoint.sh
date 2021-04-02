#!/bin/bash

# can't be done during container build or we'll end up with hardcoded values

sed -i 's/date\.timezone.*//' /etc/php/7.4/cli/php.ini /etc/php/7.4/apache2/php.ini
echo "date.timezone = ${TZ}" >> /etc/php/7.4/cli/php.ini
echo "date.timezone = ${TZ}" >> /etc/php/7.4/apache2/php.ini

rm -rf /var/www/local.php
if [ ! -z "${DEVELOPMENT}" ]; then
  cp -rp /local.php /var/www/local.php
fi

mkdir -p /var/www/var

chown www-data:www-data /var/www/var

. /etc/apache2/envvars

/usr/sbin/apache2 -DFOREGROUND
