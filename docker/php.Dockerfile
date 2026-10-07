FROM php:8.3-cli

# git + unzip: composer needs them to resolve VCS/dist packages.
# gmp: starkbank/ecdsa uses it for signing; without it the fallback is pure PHP.
RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip libgmp-dev libzip-dev \
    && docker-php-ext-install gmp zip bcmath \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

ENV COMPOSER_HOME=/composer
