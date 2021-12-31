#!/bin/bash

# can't be done during container build or we'll end up with hardcoded values
echo "[PHP]" >> /var/www/html/php.ini

sed -i 's/date\.timezone.*//' /etc/php/${PHP_VER}/cli/php.ini /etc/php/${PHP_VER}/apache2/php.ini /var/www/html/php.ini
echo "date.timezone = ${TZ}" >> /etc/php/${PHP_VER}/cli/php.ini
echo "date.timezone = ${TZ}" >> /etc/php/${PHP_VER}/apache2/php.ini
echo "date.timezone = ${TZ}" >> /var/www/html/php.ini

rm -rf /var/www/html/local.php
if [ ! -z "${DEVELOPMENT}" ]; then
  cp -rp /local.php /var/www/html/local.php
fi

if [ "${SITE_PROTOCOL}" == "https" ]; then
	sed -i 's/session.cookie_secure.*//' /etc/php/${PHP_VER}/cli/php.ini /etc/php/${PHP_VER}/apache2/php.ini /var/www/html/php.ini
	echo "session.cookie_secure = On" >> /etc/php/${PHP_VER}/cli/php.ini
	echo "session.cookie_secure = On" >> /etc/php/${PHP_VER}/apache2/php.ini
	echo "session.cookie_secure = On" >> /var/www/html/php.ini
fi

if [ ! -z "${MEMORY_LIMIT}" ]; then
	sed -i 's/memory_limit.*//' /etc/php/${PHP_VER}/cli/php.ini /etc/php/${PHP_VER}/apache2/php.ini /var/www/html/php.ini
	echo "memory_limit = ${MEMORY_LIMIT}" >> /etc/php/${PHP_VER}/cli/php.ini
	echo "memory_limit = ${MEMORY_LIMIT}" >> /etc/php/${PHP_VER}/apache2/php.ini
	echo "memory_limit = ${MEMORY_LIMIT}" >> /var/www/html/php.ini
fi

if [ ! -z "${UPLOAD_MAX_FILESIZE}" ]; then
	sed -i 's/upload_max_filesize.*//' /etc/php/${PHP_VER}/cli/php.ini /etc/php/${PHP_VER}/apache2/php.ini /var/www/html/php.ini
	echo "upload_max_filesize = ${UPLOAD_MAX_FILESIZE}" >> /etc/php/${PHP_VER}/cli/php.ini
	echo "upload_max_filesize = ${UPLOAD_MAX_FILESIZE}" >> /etc/php/${PHP_VER}/apache2/php.ini
	echo "upload_max_filesize = ${UPLOAD_MAX_FILESIZE}" >> /var/www/html/php.ini
fi

if [ ! -z "${POST_MAX_SIZE}" ]; then
	sed -i 's/post_max_size.*//' /etc/php/${PHP_VER}/cli/php.ini /etc/php/${PHP_VER}/apache2/php.ini /var/www/html/php.ini
	echo "post_max_size = ${POST_MAX_SIZE}" >> /etc/php/${PHP_VER}/cli/php.ini
	echo "post_max_size = ${POST_MAX_SIZE}" >> /etc/php/${PHP_VER}/apache2/php.ini
	echo "post_max_size = ${POST_MAX_SIZE}" >> /var/www/html/php.ini
fi

mkdir -p /var/www/html/var

chown www-data:www-data /var/www/html/var

. /etc/apache2/envvars

/usr/sbin/apache2 -DFOREGROUND
