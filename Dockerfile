FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get install -y \
      nginx \
      php-fpm \
      php-xml \
      php-mysql \
      php-gd \
      php-mbstring \
      imagemagick \
      graphicsmagick \
      dcraw \
      ffmpeg \
      git \
      mysql-client \
      && \
   apt-get clean autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

#RUN \
#  git clone https://github.com/bwdutton/gallery3.git && \ 
#  cd /gallery3 && git checkout 3.1.0 && rm -rf .git 
RUN \
  git clone https://github.com/bwdutton/gallery3.git && \ 
  cd /gallery3 && git checkout master && rm -rf .git 

RUN \
  git clone https://github.com/bwdutton/gallery3-contrib.git && \
  mv /gallery3-contrib/3.0/modules/* /gallery3/modules/ && rm -rf /gallery3-contrib

RUN rm -rf /var/www/*
RUN cp -r /gallery3/. /var/www/ 
RUN rm -rf /gallery3 

ADD nginx-gallery.conf /etc/nginx/sites-enabled/default

VOLUME ["/var/www/var"]

RUN chown -R www-data:www-data /var/www/*

ADD entrypoint.sh /entrypoint.sh

RUN chmod 0777 /var/www/var /entrypoint.sh

RUN mkdir /run/php

RUN echo "short_open_tag = On" >> /etc/php/7.3/fpm/php.ini

EXPOSE 80

CMD /entrypoint.sh
#CMD tail -f /dev/null
