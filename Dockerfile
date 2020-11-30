FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive
ENV TZ UTC

RUN set -ex && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
      ca-certificates \
      composer \
      nginx \
      php-fpm \
      php-xml \
      php-mysql \
      php-gd \
      php-mbstring \
      php-redis \
      imagemagick \
      graphicsmagick \
      dcraw \
      ffmpeg \
      git \
      mysql-client \
      && \
   apt-get clean autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN \
  git clone https://github.com/bwdutton/gallery3.git && \ 
  cd /gallery3 && git checkout 3.1.3 && rm -rf .git && \
  sed -i 's/"index.php"/""/g' application/config/config.php && \
  cd / && \
  git clone https://github.com/bwdutton/gallery3-contrib.git && \
  mv /gallery3-contrib/3.0/modules/* /gallery3/modules/ && \
  mv /gallery3-contrib/3.0/themes/* /gallery3/themes/ && \
  rm -rf /gallery3-contrib && \
  rm -rf /var/www/* && \
  cp -r /gallery3/. /var/www/ && \
  rm -rf /gallery3 && \
  chown -R www-data:www-data /var/www/* && \
  cd /var/www && \
  rm -rf modules/dropzone && \
  # this is built in now, remove it as to no confuse people
  composer install && \
  composer clear-cache

ADD local.php nginx-gallery.conf entrypoint.sh php-fpm.conf /

VOLUME ["/var/www/var"]

RUN chmod 0777 /var/www/var /entrypoint.sh && \
    mkdir -p /run/php && \
    echo "short_open_tag = On" >> /etc/php/7.4/fpm/php.ini && \
    echo "short_open_tag = On" >> /etc/php/7.4/cli/php.ini && \
    cat /php-fpm.conf >> /etc/php/7.4/fpm/pool.d/www.conf && \
    mv /nginx-gallery.conf /etc/nginx/sites-enabled/default

WORKDIR /var/www

EXPOSE 80

ENTRYPOINT [ "/entrypoint.sh" ]
