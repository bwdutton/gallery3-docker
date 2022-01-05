FROM ubuntu:impish

ARG PHP_VER=8.0
ENV PHP_VER=8.0

ENV DEBIAN_FRONTEND noninteractive
ENV TZ UTC

RUN set -ex && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
      apache2 \
      ca-certificates \
      composer \
      ghostscript \
      jhead \
      libapache2-mod-php \
      php-xml \
      php-mysql \
      php-gd \
      php-mbstring \
      php-redis \
      php-zip \
      imagemagick \
      graphicsmagick \
      dcraw \
      ffmpeg \
      git \
      mysql-client \
      unzip \
      && \
   apt-get clean autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# update github workflow file too
ARG GALLERY_VERSION=3.1.5

RUN \
  git clone https://github.com/bwdutton/gallery3.git && \ 
  cd /gallery3 && git checkout $GALLERY_VERSION && rm -rf .git && \
  cd / && \
  git clone https://github.com/bwdutton/gallery3-contrib.git && \
  mv /gallery3-contrib/3.0/modules/* /gallery3/modules/ && \
  mv /gallery3-contrib/3.0/themes/* /gallery3/themes/ && \
  rm -rf /gallery3-contrib && \
  rm -rf /var/www/* && \
  mkdir -p /var/www/html && \
  cp -r /gallery3/. /var/www/html && \
  rm -rf /gallery3 && \
  mkdir -p /var/www/html/var && \
  mv /var/www/html/bin /var/www && \
  chown -R www-data:www-data /var/www/html/var && \
  cd /var/www/html && \
  rm -rf modules/dropzone && \
  # this is built in now, remove it as to no confuse people
  composer install --no-dev --optimize-autoloader && \
  composer clear-cache

ADD local.php php.settings entrypoint.sh site.conf /

VOLUME ["/var/www/html/var"]

WORKDIR /var/www/html

RUN chmod 0777 /entrypoint.sh && \
    sed -i 's/"index.php"/""/g' application/config/config.php && \
    a2enmod rewrite && \
    mv /site.conf /etc/apache2/sites-enabled && \
    rm /etc/apache2/sites-enabled/000-default.conf && \
    cat /php.settings >> /etc/php/${PHP_VER}/cli/php.ini && \
    cat /php.settings >> /etc/php/${PHP_VER}/apache2/php.ini

EXPOSE 80

ENTRYPOINT [ "/entrypoint.sh" ]
