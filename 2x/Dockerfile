FROM php:5.6.7

RUN apt-get update && \
    \
    apt-get install -y --no-install-recommends \
        libldap2-dev \
        libldb-dev \
        libmcrypt-dev \
        libsodium-dev

RUN docker-php-ext-install \
        pdo_mysql && \
    \
    pecl install \
        libsodium-1.0.6 \
        xdebug && \
    \
    echo "zend_extension=xdebug.so" > "$(php-config --prefix)/etc/php/conf.d/xdebug.ini" && \
    echo "extension=libsodium.so" > "$(php-config --prefix)/etc/php/conf.d/libsodium.ini"

RUN docker-php-ext-configure \
        ldap --with-libdir="lib/x86_64-linux-gnu" && \
    \
    docker-php-ext-install \
        mcrypt \
        ldap
