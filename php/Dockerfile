FROM php:8.2-apache

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Enable Apache modules required for Magento
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl
RUN a2enmod expires

# Disable default Apache site to avoid conflicts
RUN a2dissite 000-default.conf

RUN apt-get update \
  && apt-get install -y --no-install-recommends locales apt-utils git libicu-dev g++ libpng-dev libxml2-dev libzip-dev libonig-dev libxslt-dev unzip curl gnupg libcurl4-openssl-dev pkg-config libssl-dev libmagickwand-dev imagemagick ghostscript cron

# RUN pecl install xdebug \
#   && docker-php-ext-enable xdebug \
#   && echo "xdebug.mode=debug,develop,profile,coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#   && echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#   && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini\
#   && echo "xdebug.output_dir=/tmp/profile" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen  \
  &&  echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
  &&  locale-gen

RUN curl -sS https://getcomposer.org/installer | php -- \
  &&  mv composer.phar /usr/local/bin/composer

RUN set -eux; \
    docker-php-ext-install pdo_mysql; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install gd; \
    docker-php-ext-install mbstring; \
    docker-php-ext-install zip; \
    docker-php-ext-install intl; \
    docker-php-ext-install xsl; \
    docker-php-ext-install soap; \
    docker-php-ext-install ftp; \
    docker-php-ext-install sockets; \
    docker-php-ext-install bcmath

# Change www-data UID/GID to match host user (1000:1000)
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# Copier le point d'entrée simple
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/entrypoint.sh"]