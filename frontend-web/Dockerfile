FROM nginx:1.15.1

ENV PHP_VERSION 7.3

# Install system and php dependencies
RUN apt-get update && \
    apt-get install -y \
        bzip2 \
        curl \
        supervisor \
        apt-transport-https \
        ca-certificates \
    && \
    curl -sS \
        -o /etc/apt/trusted.gpg.d/php.gpg \
        https://packages.sury.org/php/apt.gpg \
    && \
    echo "deb https://packages.sury.org/php/ stretch main" | tee \
        /etc/apt/sources.list.d/php.list \
    && \
    apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    mkdir -p /usr/share/man/man7 && \
    apt-get install -y \
        php${PHP_VERSION} \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-ldap \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-pgsql \
        php${PHP_VERSION}-phpdbg \
        php${PHP_VERSION}-sqlite3 \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-zip \
    && rm -rf "/var/lib/apt/lists/*"

# Install optional dependencies
RUN apt-get update && \
    apt-get install -y \
        sqlite \
        postgresql-client \
        mysql-client \
    && rm -rf "/var/lib/apt/lists/*"

RUN ln -sf /dev/stdout /var/log/php${PHP_VERSION}-fpm.log

RUN touch /var/run/nginx.pid && \
    chown www-data:root /var/run/nginx.pid \
    && \
    touch /var/run/fpm.pid && \
    chown www-data:root /var/run/fpm.pid

WORKDIR /app

RUN mkdir -p /usr/share/nginx/cache && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /var/lib/nginx && \
    chown www-data:root \
        /app && \
    chown -R www-data:root \
        /usr/share/nginx/cache \
        /var/cache/nginx \
        /var/lib/nginx/ \
        /etc/php/${PHP_VERSION}/fpm/pool.d

RUN chmod -R g+rw \
    /usr/share/nginx/cache \
    /var/cache/nginx \
    /var/lib/nginx

