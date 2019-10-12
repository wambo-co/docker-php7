FROM php:7.3-fpm-buster

ENV PHP_EXTRA_CONFIGURE_ARGS \
  --enable-fpm \
  --with-fpm-user=www-data \
  --with-fpm-group=www-data \
  --enable-intl \
  --enable-opcache \
  --enable-zip \
  --enable-calendar

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libpng-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libxml2-dev \
        libfreetype6-dev \
        libxslt-dev \
        libzip-dev \
        git \
        unzip \
        default-mysql-client \
        && \
    rm -rf /var/lib/apt/lists/*


RUN docker-php-ext-configure gd \
  --with-freetype-dir=/usr \
  --with-jpeg-dir=/usr \
  --with-png-dir=/usr \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    hash \
    simplexml \
    xsl \
    soap \
    intl \
    bcmath \
    json \
    opcache \
    zip \
    calendar \
    gd

COPY php.ini          /usr/local/etc/php/php.ini
COPY php-fpm.conf     /usr/local/etc/php-fpm.conf

RUN curl -O https://files.magerun.net/n98-magerun.phar && \
    chmod +x n98-magerun.phar && \
    mv n98-magerun.phar /usr/local/bin/magerun

RUN pecl install xdebug