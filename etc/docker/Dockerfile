FROM php:7.1-fpm-alpine

ENV PHPREDIS_VERSION 3.0.0

RUN echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
  && apk update \
  && apk add --no-cache icu icu-libs icu-dev libxml2-dev php7-bcmath@community ca-certificates curl openssl \
  && update-ca-certificates \
  && mkdir -p /usr/src/php/ext \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl mbstring soap sockets zip bcmath \
  && rm -rf /usr/src/php/ /usr/share/perl5/ \
  && rm -r /usr/local/bin/phpdbg /usr/local/bin/phpize /usr/local/bin/pear /usr/local/bin/peardev /usr/local/bin/pecl /usr/local/bin/docker-php-ext-install \
  /usr/local/bin/docker-php-ext-configure /usr/local/bin/docker-php-entrypoint /usr/local/bin/docker-php-source /usr/local/bin/phar /usr/local/bin/phar.phar

COPY . /var/www

WORKDIR /var/www/html

ENTRYPOINT /usr/local/sbin/php-fpm