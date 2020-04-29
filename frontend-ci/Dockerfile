FROM debian:buster-slim

ENV PHP_VERSION      7.3
ENV COMPOSER_VERSION 1.6.3
ENV DEBIAN_FRONTEND  noninteractive

ARG APCU_VERSION="5.1.18"

# Install system and php dependencies
RUN apt-get update && \
    apt-get install -y \
        bzip2 \
        curl \
        apt-transport-https \
        ca-certificates \
    && \
    curl -sS \
        -o /etc/apt/trusted.gpg.d/php.gpg \
        https://packages.sury.org/php/apt.gpg \
    && \
    echo "deb https://packages.sury.org/php/ buster main" | tee \
        /etc/apt/sources.list.d/php.list \
    && \
    apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    mkdir -p /usr/share/man/man7 && \
    apt-get install -y \
        php${PHP_VERSION} \
        php${PHP_VERSION}-dev \
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
    && \
    pecl install "apcu-${APCU_VERSION}" \
    echo 'extension=apcu.so' > /etc/php/${PHP_VERSION}/cli/conf.d/20-apcu.ini \
    && rm -rf "/var/lib/apt/lists/*"

# Install composer
RUN curl -sSo /tmp/composer-setup.php \
        https://getcomposer.org/installer \
        && \
    curl -sSo /tmp/composer-setup.sig \
        https://composer.github.io/installer.sig \
        && \
    php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
        && \
    php /tmp/composer-setup.php \
        --version=${COMPOSER_VERSION} \
        --filename=composer \
        --install-dir=bin \
        && \
    rm -f "/tmp/composer-setup.*"

# Run setup for Circle CI

# make Apt non-interactive
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci \
  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci

# https://github.com/circleci/circleci-images/blob/staging/shared/images/Dockerfile-basic.template#L11
RUN apt-get update \
  && mkdir -p /usr/share/man/man1 \
  && apt-get install -y \
    git mercurial xvfb \
    locales sudo openssh-client ca-certificates tar gzip parallel \
    net-tools netcat unzip zip bzip2 gnupg curl wget

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Use unicode
RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8

RUN groupadd --gid 3434 circleci \
  && useradd --uid 3434 --gid circleci --shell /bin/bash --create-home circleci \
  && echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci \
  && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

USER circleci

CMD ["/bin/sh"]
