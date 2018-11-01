FROM php:5.6.7

# Buildpack

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        openssh-client \
        bzip2 \
        ca-certificates \
        curl \
    && rm -rf /var/lib/apt/lists/*

# PHP

RUN apt-get update && \
    \
    apt-get install -y --no-install-recommends \
        libldap2-dev \
        libldb-dev \
        libmcrypt-dev \
        libsodium-dev \
        zlib1g-dev

RUN docker-php-ext-install \
        zip \
        mbstring \
        pdo_mysql && \
    \
    pecl install \
        libsodium-1.0.6 \
        xdebug-2.5.5 && \
    \
    echo "zend_extension=xdebug.so" > "$(php-config --prefix)/etc/php/conf.d/xdebug.ini" && \
    echo "extension=libsodium.so" > "$(php-config --prefix)/etc/php/conf.d/libsodium.ini"

RUN docker-php-ext-configure \
        ldap --with-libdir="lib/x86_64-linux-gnu" && \
    \
    docker-php-ext-install \
        mcrypt \
        ldap

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    \
    php composer-setup.php --install-dir="/usr/local/bin" --filename="composer" && \
    \
    rm composer-setup.php
