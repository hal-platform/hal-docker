FROM php:7.1.8

# Update deps
RUN apt-get update && \
    rm -rf /var/lib/apt/lists/*

# Libsodium
ENV LIBSODIUM_VERSION 1.0.13
ENV LIBSODIUM_URL https://download.libsodium.org/libsodium/releases/libsodium-${LIBSODIUM_VERSION}.tar.gz
ENV LIBSODIUM_TAR /libsodium.tar.gz

RUN mkdir /libsodium && \
        cd /libsodium && \
    curl -kLo "${LIBSODIUM_TAR}" "${LIBSODIUM_URL} && \
        tar xvzf "${LIBSODIUM_TAR}" --strip-components=1 --directory=. && \
    ./configure && \
        make && \
        make check && \
        make install && \
    mv src/libsodium /usr/local/ && \
        rm -rf /libsodium && \
    pecl install libsodium-${LIBSODIUM_VERSION} && \
        docker-php-ext-configure libsodium && \
        docker-php-ext-install libsodium

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php
