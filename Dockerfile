FROM php:7.1-fpm

ENV PHP_EXTRA_CONFIGURE_ARGS \
  --enable-fpm \
  --with-fpm-user=www-data \
  --with-fpm-group=www-data \
  --enable-intl \
  --enable-opcache \
  --enable-zip \
  --enable-calendar

RUN apt-get update && \
  apt-get install -y \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libssl-dev \
    g++ \
    autoconf \
    libbz2-dev \
    libltdl-dev \
    libpng12-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxpm-dev \
    libimlib2-dev \
    libicu-dev \
    libmcrypt-dev \
    libxslt1-dev \
    re2c \
    libpng++-dev \
    libpng3 \
    libvpx-dev \
    zlib1g-dev \
    libgd-dev \
    libtidy-dev \
    libmagic-dev \
    libexif-dev \
    file \
    libssh2-1-dev \
    libjpeg-dev \
    git \
    curl \
    wget \
    librabbitmq-dev \
    libzip-dev \
    libzip2

RUN docker-php-ext-configure \
      gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr


RUN docker-php-ext-install \
      dom \
      pcntl \
      posix \
      pdo \
      sockets \
      pdo_mysql \
      mysqli \
      mbstring \
      mcrypt \
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


# Install xdebug
RUN cd /tmp/ && git clone https://github.com/xdebug/xdebug.git \
    && cd xdebug && phpize && ./configure --enable-xdebug && make \
    && mkdir /usr/lib/php7/ && cp modules/xdebug.so /usr/lib/php7/xdebug.so \
    && touch /usr/local/etc/php/ext-xdebug.ini \
    && rm -r /tmp/xdebug \
    && apt-get purge -y --auto-remove

COPY php.ini          /usr/local/etc/php/php.ini
COPY php-fpm.conf     /usr/local/etc/php-fpm.conf

# Install redis
ENV PHPREDIS_VERSION 3.1.4
RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis
