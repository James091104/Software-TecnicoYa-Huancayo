FROM php:8.2-cli-bookworm
RUN apt-get update && apt-get install -y --no-install-recommends git unzip libpq-dev && docker-php-ext-install pdo_pgsql && rm -rf /var/lib/apt/lists/*
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist --no-interaction
COPY . .
RUN composer dump-autoload --optimize --no-dev && mkdir -p storage/logs storage/framework/cache/data storage/framework/sessions storage/framework/views bootstrap/cache && chown -R www-data:www-data storage bootstrap/cache && chmod +x docker/entrypoint.sh
ARG PORT=3000
ENV PORT=${PORT}
EXPOSE ${PORT}
USER www-data
ENTRYPOINT ["docker/entrypoint.sh"]
