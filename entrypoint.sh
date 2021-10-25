#!/bin/bash

# can't be done during container build or we'll end up with hardcoded values
echo "[PHP]" >> /var/www/html/php.ini

sed -i 's/date\.timezone.*//' /etc/php/7.4/cli/php.ini /etc/php/7.4/apache2/php.ini /var/www/html/php.ini
echo "date.timezone = ${TZ}" >> /etc/php/7.4/cli/php.ini
echo "date.timezone = ${TZ}" >> /etc/php/7.4/apache2/php.ini
echo "date.timezone = ${TZ}" >> /var/www/html/php.ini

rm -rf /var/www/html/local.php
if [ ! -z "${DEVELOPMENT}" ]; then
  cp -rp /local.php /var/www/html/local.php
fi

if [ ! -z "${MAX_UPLOAD}" ]; then
	sed -i 's/upload_max_filesize.*//' /etc/php/7.4/cli/php.ini /etc/php/7.4/apache2/php.ini /var/www/html/php.ini
	echo "upload_max_filesize = ${MAX_UPLOAD}" >> /etc/php/7.4/cli/php.ini
	echo "upload_max_filesize = ${MAX_UPLOAD}" >> /etc/php/7.4/apache2/php.ini
	echo "upload_max_filesize = ${MAX_UPLOAD}" >> /var/www/html/php.ini
fi

if [ ! -z "${MAX_POST}" ]; then
	sed -i 's/post_max_size.*//' /etc/php/7.4/cli/php.ini /etc/php/7.4/apache2/php.ini /var/www/html/php.ini
	echo "post_max_size = ${MAX_POST}" >> /etc/php/7.4/cli/php.ini
	echo "post_max_size = ${MAX_POST}" >> /etc/php/7.4/apache2/php.ini
	echo "post_max_size = ${MAX_POST}" >> /var/www/html/php.ini
fi

mkdir -p /var/www/html/var

chown www-data:www-data /var/www/html/var

. /etc/apache2/envvars

/usr/sbin/apache2 -DFOREGROUND
