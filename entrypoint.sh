#!/bin/bash

chown www-data:www-data /var/www/var

/etc/init.d/nginx start

/usr/sbin/php-fpm7.3 --nodaemonize
