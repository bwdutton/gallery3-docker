#!/bin/bash

# can't be done during container build or we'll end up with hardcoded values
echo "date.timezone = ${TZ}" >> /etc/php/7.4/cli/php.ini
echo "date.timezone = ${TZ}" >> /etc/php/7.4/fpm/php.ini

chown www-data:www-data /var/www/var

/etc/init.d/nginx start

/usr/sbin/php-fpm7.4 --nodaemonize
