FROM php:7.2-fpm-stretch

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
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxpm-dev \
    libimlib2-dev \
    libicu-dev \
    libmcrypt-dev \
    libxslt1-dev \
    re2c \
    libpng++-dev \
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
    libzip-dev 


RUN docker-php-ext-configure \
      gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr

RUN pecl install mcrypt-1.0.1
RUN docker-php-ext-enable mcrypt

RUN /usr/local/bin/docker-php-ext-install \
      dom \
      pcntl \
      phar \
      posix \
      pdo \
      sockets \
      pdo_mysql \
      mysqli \
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


# Install xdebug
RUN cd /tmp/ && git clone https://github.com/xdebug/xdebug.git \
    && cd xdebug && phpize && ./configure --enable-xdebug && make \
    && mkdir /usr/lib/php7/ && cp modules/xdebug.so /usr/lib/php7/xdebug.so \
    && touch /usr/local/etc/php/ext-xdebug.ini \
    && rm -r /tmp/xdebug \
    && apt-get purge -y --auto-remove

COPY php.ini          /usr/local/etc/php/php.ini
COPY php-fpm.conf     /usr/local/etc/php-fpm.conf
#COPY ext-xdebug.ini   /usr/local/etc/php/conf.d/ext-xdebug.ini
