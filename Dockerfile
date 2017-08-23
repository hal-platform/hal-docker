FROM php:7.1.8

# Base PHP configuration
ENV BASE_PACKAGES         "git"
ENV PHP_DEPENDENCIES      "libmemcached-dev libpq-dev libsqlite3-dev zlib1g-dev"
ENV PHP_DEPENDENCIES_KEEP "libmemcached11 libmemcachedutil2 libpq5"

ENV PHP_EXTENSIONS        "mbstring opcache pdo pdo_mysql pdo_pgsql pdo_sqlite zip zlib"
ENV PECL_EXTENSIONS       "memcached"

# OMG PHP really? https://github.com/docker-library/php/issues/233
RUN sed -i '/^phpize$/ i\
if [ ! -f "config.m4" -a -f "config0.m4" ] ; then mv config0.m4 config.m4; fi' \
    $(which docker-php-ext-configure)

# Update system deps and install php packages
RUN apt-get update && \
    apt-get install -y ${BASE_PACKAGES} ${PHP_DEPENDENCIES} && \
    rm -rf /var/lib/apt/lists/* && \
    \
    docker-php-ext-install ${PHP_EXTENSIONS} && \
    \
    pecl install ${PECL_EXTENSIONS} && \
    docker-php-ext-enable ${PECL_EXTENSIONS} && \
    \
    apt-mark manual ${PHP_DEPENDENCIES_KEEP} && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${PHP_DEPENDENCIES}

# Install Libsodium
ENV LIBSODIUM_VERSION      1.0.13
ENV PECL_LIBSODIUM_VERSION 2.0.4

ENV LIBSODIUM_URL "https://download.libsodium.org/libsodium/releases/libsodium-${LIBSODIUM_VERSION}.tar.gz"
ENV LIBSODIUM_TAR "/libsodium.tar.gz"

RUN mkdir /libsodium && \
    cd /libsodium && \
    \
    curl -kLo "${LIBSODIUM_TAR}" "${LIBSODIUM_URL}" && \
    tar xvzf "${LIBSODIUM_TAR}" --strip-components=1 --directory=. && \
    \
    ./configure && \
    make && make check && \
    make install && \
    \
    pecl install "libsodium-${PECL_LIBSODIUM_VERSION}" && \
    docker-php-ext-enable sodium && \
    \
    cd / && rm -rf /libsodium

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    \
    php composer-setup.php --install-dir="/usr/local/bin" --filename="composer" && \
    \
    rm composer-setup.php

