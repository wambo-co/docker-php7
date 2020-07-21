FROM php:7.4-fpm

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
    libzip-dev \
    libonig-dev

RUN docker-php-ext-configure \
      gd --with-freetype --with-jpeg

RUN docker-php-ext-install \
      dom \
      pcntl \
      posix \
      pdo \
      sockets \
      pdo_mysql \
      mysqli \
      mbstring \
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

RUN curl -o /usr/local/bin/composer https://getcomposer.org/composer.phar && \
    chmod +x /usr/local/bin/composer

# install xdebug
RUN pecl install --nocompress xdebug-2.9.2

# install redis
RUN pecl install --nocompress redis && docker-php-ext-enable redis

# install magerun
RUN apt update && apt install default-mysql-client -y
RUN wget https://files.magerun.net/n98-magerun.phar && \
    chmod +x ./n98-magerun.phar && \
    mv ./n98-magerun.phar /usr/local/bin/magerun

# install blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

RUN usermod -u 1000 www-data \
    && usermod -G www-data www-data
