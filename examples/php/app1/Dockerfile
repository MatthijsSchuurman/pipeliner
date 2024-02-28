FROM php:8.3-cli-alpine

RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /home/www-data/app
USER www-data:www-data

COPY --chown=www-data:www-data . .
RUN composer install --no-dev

EXPOSE 8080
CMD [ "php", "src/index.php" ]