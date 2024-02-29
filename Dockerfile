FROM php:8.2-cli

RUN apt update \
    && apt install -y libpq-dev \
                      zip \
                      unzip \
                      p7zip-full \
                      telnet \
                      curl

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN set -eux;

# instalando extensão mysql para pdo
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install sockets
# Installing extension for Memcached
RUN apt install -y libz-dev libmemcached-dev && pecl install memcached && docker-php-ext-enable memcached

RUN pecl install swoole
RUN docker-php-ext-enable swoole

ENV COMPOSER_ALLOW_SUPERUSER=1

# baixar o composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.* ./

COPY framework /var/www/html/framework
WORKDIR /var/www/html/framework
RUN composer install --prefer-dist --no-scripts --no-progress --no-interaction

WORKDIR /var/www/html
RUN composer install --prefer-dist --no-scripts --no-progress --no-interaction

RUN composer dump-autoload --optimize

CMD ["php", "/var/www/html/public/server.php", "swoole-server"]
#CMD ["php", "-S", "0.0.0.0:8000", "-t", "/var/www/html/public", "/var/www/html/public/index.php"]
#CMD ["nodemon -L", "/var/www/html/public/server.php"]
